import json
import re
import requests
from datetime import datetime
from typing import Dict, List, Optional, Set, Any, TypedDict


class ReleaseAsset(TypedDict):
    browser_download_url: str
    name: str
    size: int


class GitHubRelease(TypedDict):
    tag_name: str
    published_at: str
    body: str
    assets: List[ReleaseAsset]


class VersionEntry(TypedDict):
    version: str
    date: str
    localizedDescription: str
    downloadURL: Optional[str]
    size: Optional[int]


class AppInfo(TypedDict):
    versions: List[VersionEntry]
    version: str
    versionDate: str
    versionDescription: str
    downloadURL: Optional[str]
    size: Optional[int]


class NewsEntry(TypedDict):
    appID: str
    title: str
    identifier: str
    caption: str
    date: str
    tintColor: str
    imageURL: str
    notify: bool
    url: str


class AppData(TypedDict):
    apps: List[Dict[str, Any]]
    news: List[NewsEntry]


REPO_URL: str = "tanakrit-d/mangayomi-workflow-test"
JSON_FILE: str = "repo/source.json"
APP_ID: str = "com.kodjodevf.mangayomi"
APP_NAME: str = "Mangayomi"
CAPTION = f"Update for {APP_NAME} now available!"
IMAGE_URL = f"https://raw.githubusercontent.com/{REPO_URL}/refs/heads/main/repo/images/news/update_default.webp"
TINT_COLOUR = "EF4444"


def fetch_all_releases() -> List[GitHubRelease]:
    """
    Fetch all GitHub releases for the repository, sorted by published date (oldest first).

    Returns:
        List[GitHubRelease]: List of all releases sorted by publication date
    """
    api_url: str = f"https://api.github.com/repos/{REPO_URL}/releases"
    headers: Dict[str, str] = {"Accept": "application/vnd.github+json"}

    response = requests.get(api_url, headers=headers)
    response.raise_for_status()  # Raise exception for HTTP errors

    releases: List[GitHubRelease] = response.json()
    sorted_releases = sorted(releases, key=lambda x: x["published_at"], reverse=False)

    return sorted_releases


def fetch_latest_release() -> GitHubRelease:
    """
    Fetch the latest GitHub release for the repository.

    Returns:
        GitHubRelease: The latest release

    Raises:
        ValueError: If no releases are found
    """
    api_url: str = f"https://api.github.com/repos/{REPO_URL}/releases"
    headers: Dict[str, str] = {"Accept": "application/vnd.github+json"}

    response = requests.get(api_url, headers=headers)
    response.raise_for_status()  # Raise exception for HTTP errors

    releases: List[GitHubRelease] = response.json()
    sorted_releases = sorted(releases, key=lambda x: x["published_at"], reverse=True)

    if sorted_releases:
        return sorted_releases[0]

    raise ValueError("No release found.")


def purge_old_news(data: AppData, fetched_versions: List[str]) -> None:
    """
    Remove news entries for versions that no longer exist.

    Args:
        data: The app data dictionary
        fetched_versions: List of valid version strings
    """
    if "news" not in data:
        return

    valid_identifiers: Set[str] = {f"release-{version}" for version in fetched_versions}
    data["news"] = [
        entry for entry in data["news"] if entry["identifier"] in valid_identifiers
    ]


def format_description(description: str) -> str:
    """
    Format release description by removing HTML tags and replacing certain characters.

    Args:
        description: The raw description text

    Returns:
        str: Cleaned description text
    """
    # Remove HTML tags
    formatted = re.sub(r"<[^<]+?>", "", description)  # HTML tags
    formatted = re.sub(r"#{1,6}\s?", "", formatted)  # Markdown header tags
    formatted = formatted.replace(r"\*{2}", "").replace("-", "•").replace("`", '"')

    return formatted


def find_download_url_and_size(
    release: GitHubRelease,
) -> tuple[Optional[str], Optional[int]]:
    """
    Find the download URL and size for a release's IPA file.

    Args:
        release: The GitHub release

    Returns:
        tuple: (download_url, size) or (None, None) if not found
    """
    # Find IPA asset
    for asset in release["assets"]:
        if asset["name"].endswith(".ipa"):
            return asset["browser_download_url"], asset["size"]

    return None, None


def update_json_file(
    json_file: str,
    fetched_data_all: List[GitHubRelease],
    fetched_data_latest: GitHubRelease,
) -> None:
    """
    Update the apps.json file with the fetched GitHub releases.

    Args:
        json_file: Path to the JSON file
        fetched_data_all: List of all GitHub releases
        fetched_data_latest: The latest GitHub release
    """
    with open(json_file, "r") as file:
        data: AppData = json.load(file)

    app = data["apps"][0]

    # Initialize versions list if it doesn't exist
    if "versions" not in app:
        app["versions"] = []

    fetched_versions: List[str] = []

    # Process all releases
    for release in fetched_data_all:
        full_version = release["tag_name"].lstrip("v")
        version_match = re.search(r"(\d+\.\d+\.\d+)(?:-([a-zA-Z0-9]+))?", full_version)

        if not version_match:
            continue

        version_date = release["published_at"]
        fetched_versions.append(full_version)

        # Clean up description
        description = release["body"]
        keyword = "{APP_NAME} Release Information"
        if keyword in description:
            description = description.split(keyword, 1)[1].strip()

        description = format_description(description)

        # Find download URL and size
        download_url, size = find_download_url_and_size(release)

        # Create version entry
        version_entry: VersionEntry = {
            "version": full_version,
            "date": version_date,
            "localizedDescription": description,
            "downloadURL": download_url,
            "size": size,
        }

        # Remove existing entry with the same version
        app["versions"] = [v for v in app["versions"] if v["version"] != full_version]

        # Add new entry if download URL exists
        if download_url:
            app["versions"].insert(0, version_entry)

    # Update app info with latest release
    latest_version = fetched_data_latest["tag_name"].lstrip("v")
    tag = fetched_data_latest["tag_name"]
    version_match = re.search(r"(\d+\.\d+\.\d+)(?:-([a-zA-Z0-9]+))?", latest_version)

    print(full_version)

    if not version_match:
        raise ValueError("Invalid version format")

    app["version"] = full_version
    app["versionDate"] = fetched_data_latest["published_at"]
    app["versionDescription"] = format_description(fetched_data_latest["body"])

    # Find latest download URL and size
    download_url, size = find_download_url_and_size(fetched_data_latest)
    app["downloadURL"] = download_url
    app["size"] = size

    # Update news entries
    purge_old_news(data, fetched_versions)

    if "news" not in data:
        data["news"] = []

    # Add news entry for the latest version if it doesn't exist
    news_identifier = f"release-{latest_version}"
    if not any(item["identifier"] == news_identifier for item in data["news"]):
        formatted_date = datetime.strptime(
            fetched_data_latest["published_at"], "%Y-%m-%dT%H:%M:%SZ"
        ).strftime("%d %b")

        news_entry: NewsEntry = {
            "appID": APP_ID,
            "title": f"{latest_version} - {formatted_date}",
            "identifier": news_identifier,
            "caption": CAPTION,
            "date": fetched_data_latest["published_at"],
            "tintColor": TINT_COLOUR,
            "imageURL": IMAGE_URL,
            "notify": True,
            "url": f"https://github.com/{REPO_URL}/releases/tag/{tag}",
        }
        data["news"].append(news_entry)

    # Write updated data back to file
    with open(json_file, "w") as file:
        json.dump(data, file, indent=2)


def main() -> None:
    """
    Entrypoint for GitHub workflow action.
    """
    try:
        fetched_data_all = fetch_all_releases()
        fetched_data_latest = fetch_latest_release()
        update_json_file(JSON_FILE, fetched_data_all, fetched_data_latest)
        print(f"Successfully updated {JSON_FILE} with latest releases.")
    except Exception as e:
        print(f"Error updating releases: {e}")


if __name__ == "__main__":
    main()
