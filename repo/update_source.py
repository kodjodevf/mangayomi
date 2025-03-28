import json
import re
import requests
from datetime import datetime
from typing import Dict, List, Optional, Any, TypedDict


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


class AppConfig(TypedDict):
    repo_url: str
    json_file: str
    app_id: str
    app_name: str
    caption: str
    tint_colour: str
    image_url: str


def load_config(config_path: str) -> AppConfig:
    """
    Load repo configuration values.
    """
    try:
        with open(config_path, 'r') as config_file:
            config_data = json.load(config_file)
        
        return {
            "repo_url": config_data["repo_url"],
            "json_file": config_data["json_file"],
            "app_id": config_data["app_id"],
            "app_name": config_data["app_name"],
            "caption": config_data["caption"],
            "tint_colour": config_data["tint_colour"],
            "image_url": config_data["image_url"],
        }
    
    except FileNotFoundError:
        print(f"Configuration file not found at {config_path}")
        raise
    except (json.JSONDecodeError, KeyError) as e:
        print(f"Error parsing configuration: {e}")
        raise


def fetch_all_releases(repo_url: str) -> List[GitHubRelease]:
    """
    Fetch all GitHub releases for the repository, sorted by published date (oldest first).

    Returns:
        List[GitHubRelease]: List of all releases sorted by publication date
    """
    api_url: str = f"https://api.github.com/repos/{repo_url}/releases"
    headers: Dict[str, str] = {"Accept": "application/vnd.github+json"}

    response = requests.get(api_url, headers=headers)
    response.raise_for_status()  # Raise exception for HTTP errors

    releases: List[GitHubRelease] = response.json()
    sorted_releases = sorted(releases, key=lambda x: x["published_at"], reverse=False)

    return sorted_releases


def fetch_latest_release(repo_url: str) -> GitHubRelease:
    """
    Fetch the latest GitHub release for the repository.

    Returns:
        GitHubRelease: The latest release

    Raises:
        ValueError: If no releases are found
    """
    api_url: str = f"https://api.github.com/repos/{repo_url}/releases"
    headers: Dict[str, str] = {"Accept": "application/vnd.github+json"}

    response = requests.get(api_url, headers=headers)
    response.raise_for_status()  # Raise exception for HTTP errors

    releases: List[GitHubRelease] = response.json()
    sorted_releases = sorted(releases, key=lambda x: x["published_at"], reverse=True)

    if sorted_releases:
        return sorted_releases[0]

    raise ValueError("No release found.")


# 2025-03-25: Reimplement this at a later date (@tanakrit-d)
# def purge_old_news(data: AppData, fetched_versions: List[str]) -> None:
#     """
#     Remove news entries for versions that no longer exist.

#     Args:
#         data: The app data dictionary
#         fetched_versions: List of valid version strings
#     """
#     if "news" not in data:
#         return

#     valid_identifiers: Set[str] = {f"release-{version}" for version in fetched_versions}
#     data["news"] = [
#         entry for entry in data["news"] if entry["identifier"] in valid_identifiers
#     ]


def format_description(description: str) -> str:
    """
    Format release description by removing HTML tags and replacing certain characters.

    Args:
        description: The raw description text

    Returns:
        str: Cleaned description text
    """
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
    for asset in release["assets"]:
        if asset["name"].endswith(".ipa"):
            return asset["browser_download_url"], asset["size"]

    return None, None


def normalize_version(version: str) -> str:
    """
    Strip the version tag (e.g., -hotfix) from a version string.

    Args:
        version: Version string (e.g., v0.5.2-hotfix, 0.5.2-beta)

    Returns:
        Normalized version string without the tag (e.g., 0.5.2)
    """
    version = version.lstrip("v")

    match = re.search(r"(\d+\.\d+\.\d+)", version)
    if match:
        return match.group(1)
    return version


def process_versions(versions_data: List[VersionEntry]) -> List[VersionEntry]:
    """
    Process the versions list to remove duplicate versions, keeping the newest version.

    Args:
        versions_data (List[VersionEntry]): List of version dictionaries containing:
                                            version: str
                                            date: str
                                            localizedDescription: str
                                            downloadURL: Optional[str]
                                            size: Optional[int]

    Returns:
        List[VersionEntry]: Processed list with only the newest versions.
    """
    # Create a list to store unique versions with their details
    version_entries: List[VersionEntry] = []

    # Iterate through the versions in the order they appear
    for version in versions_data:
        # Parse the date for comparison
        current_date = datetime.fromisoformat(version["date"].replace("Z", "+00:00"))

        # Check if this version already exists in unique_versions
        existing_version_index = next(
            (
                index
                for index, v in enumerate(version_entries)
                if v["version"] == version["version"]
            ),
            None,
        )

        if existing_version_index is not None:
            # Compare dates and keep the newer version
            existing_date = datetime.fromisoformat(
                version_entries[existing_version_index]["date"].replace("Z", "+00:00")
            )

            if current_date > existing_date:
                version_entries[existing_version_index] = version
        else:
            # If no duplicate found, add to unique versions
            version_entries.append(version)

    return version_entries


def update_json_file(
    config: AppConfig,
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

    releases = []

    # Process all releases
    for release in fetched_data_all:
        full_version = release["tag_name"].lstrip("v")
        version_match = re.search(r"(\d+\.\d+\.\d+)(?:-([a-zA-Z0-9]+))?", full_version)

        if not version_match:
            continue

        version_date = release["published_at"]

        # Get base version without tags
        base_version = normalize_version(full_version)

        # Clean up description
        description = release["body"]
        keyword = "{APP_NAME} Release Information"
        if keyword in description:
            description = description.split(keyword, 1)[1].strip()
        description = format_description(description)

        # Find download URL and size
        download_url, size = find_download_url_and_size(release)

        # Skip release entries without a download URL
        if not download_url:
            continue

        # Create version entry
        version_entry: VersionEntry = {
            "version": base_version,
            "date": version_date,
            "localizedDescription": description,
            "downloadURL": download_url,
            "size": size,
        }

        releases.append(version_entry)

    deduplicated_versions = process_versions(releases)
    app["versions"] = []
    for i in deduplicated_versions:
        app["versions"].insert(0, i)
    app["versions"] = sorted(
        app["versions"], key=lambda x: x.get("date", ""), reverse=True
    )

    # Update app info with latest release
    latest_version = fetched_data_latest["tag_name"].lstrip("v")
    tag = fetched_data_latest["tag_name"]
    version_match = re.search(r"(\d+\.\d+\.\d+)(?:-([a-zA-Z0-9]+))?", latest_version)

    if not version_match:
        raise ValueError("Invalid version format")

    app["version"] = normalize_version(full_version)
    app["versionDate"] = fetched_data_latest["published_at"]
    app["versionDescription"] = format_description(fetched_data_latest["body"])

    # Find latest download URL and size
    download_url, size = find_download_url_and_size(fetched_data_latest)
    app["downloadURL"] = download_url
    app["size"] = size

    # Update news entries
    # 2025-03-25: Reimplement this at a later date (@tanakrit-d)
    # purge_old_news(data, fetched_versions)

    if "news" not in data:
        data["news"] = []

    # Add news entry for the latest version if it doesn't exist
    news_identifier = f"release-{latest_version}"
    if not any(item["identifier"] == news_identifier for item in data["news"]):
        formatted_date = datetime.strptime(
            fetched_data_latest["published_at"], "%Y-%m-%dT%H:%M:%SZ"
        ).strftime("%d %b")

        news_entry: NewsEntry = {
            "appID": config["app_id"],
            "title": f"{latest_version} - {formatted_date}",
            "identifier": news_identifier,
            "caption": config["caption"],
            "date": fetched_data_latest["published_at"],
            "tintColor": config["tint_colour"],
            "imageURL": config["image_url"],
            "notify": True,
            "url": f"https://github.com/{config["repo_url"]}/releases/tag/{tag}",
        }
        data["news"].append(news_entry)

    with open(json_file, "w") as file:
        json.dump(data, file, indent=2)


def main() -> None:
    """
    Entrypoint for GitHub workflow action.
    """
    try:
        config = load_config("repo/config.json")
        fetched_data_all = fetch_all_releases(config["repo_url"])
        fetched_data_latest = fetch_latest_release(config["repo_url"])
        update_json_file(config, "repo/source.json", fetched_data_all, fetched_data_latest)
        print("Successfully updated repo/source.json with latest releases.")
    except Exception as e:
        print(f"Error updating releases: {e}")


if __name__ == "__main__":
    main()
