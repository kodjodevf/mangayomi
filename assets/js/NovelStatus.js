// https://github.com/LNReader/lnreader/blob/master/src/plugins/types/index.ts

export let NovelStatus

;(function(NovelStatus) {
  NovelStatus["Unknown"] = "Unknown"
  NovelStatus["Ongoing"] = "Ongoing"
  NovelStatus["Completed"] = "Completed"
  NovelStatus["Licensed"] = "Licensed"
  NovelStatus["PublishingFinished"] = "Publishing Finished"
  NovelStatus["Cancelled"] = "Cancelled"
  NovelStatus["OnHiatus"] = "On Hiatus"
})(NovelStatus || (NovelStatus = {}))
