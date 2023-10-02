const RLS      = require("readline-sync");
const axios    = require("axios");
const cheerio  = require("cheerio");
const prettier = require("prettier");
const fs       = require("fs");

const query = RLS.question("Enter query: ");

async function basicSearchScrape(query, related) {
  var   url       = "https://www.youtube.com/results?search_query=" + query;
  if(related) url += " related songs";

  const response = await axios.get("https://www.youtube.com/results?search_query=" + query);
  const $        = cheerio.load(response.data);

  // Getting ytInitialData (JSON with the treasure)
  var ytInitialData;
  $("body script").each((index, script) => {
    const contents = $(script).text();

    if(contents.includes("var ytInitialData")) {
      ytInitialData = JSON.parse(
        contents.substring(
          contents.indexOf('{'),
          contents.lastIndexOf('}') + 1
        )
      );
      ytInitialData = ytInitialData.contents.twoColumnSearchResultsRenderer.primaryContents.sectionListRenderer.contents[0].itemSectionRenderer.contents;
    }
  });

  // Getting song inforamtion
  const result = [];
  for(let i = 0; i < ytInitialData.length; i++) {
    if(ytInitialData[i].hasOwnProperty("videoRenderer")) {
      const data  = ytInitialData[i].videoRenderer;
      const split = data.lengthText.simpleText.split(':');

      result.push({
        videoID:   data.videoId,
        title:     data.title.runs[0].text,
        channel:   data.longBylineText.runs[0].text,
        pfp:       data.channelThumbnailSupportedRenderers.channelThumbnailWithLinkRenderer.thumbnail.thumbnails[0].url,
        lengthStr: data.lengthText.simpleText,
        lengthInt: (split[0] * 60) + split[1]
      });
    }
  }

  return result;
}

basicSearchScrape(query, true).then(result => console.log(result));
