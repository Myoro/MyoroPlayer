const RLS      = require("readline-sync");
const axios    = require("axios");
const cheerio  = require("cheerio");
const prettier = require("prettier");
const fs       = require("fs");

const url   = "https://www.youtube.com/results?search_query=";
const query = RLS.question("Enter query: ");

async function scrape(url) {
  const response = await axios.get(url);
  const $        = cheerio.load(response.data);

  var ytInitialData;
  $("body script").each((index, obj) => {
    const contents = $(obj).text();
    if(!contents.includes("var ytInitialData")) return;
    ytInitialData = JSON.parse(
      contents.substring(
        contents.indexOf('{'),
        contents.lastIndexOf('}') + 1
      )
    );
  });
  ytInitialData = ytInitialData.contents.twoColumnSearchResultsRenderer.primaryContents.sectionListRenderer.contents[0].itemSectionRenderer.contents;

  const results = [];
  for(let i = 0; i < ytInitialData.length; i++) {
    if(ytInitialData[i].hasOwnProperty("videoRenderer")) {
      const video = ytInitialData[i].videoRenderer;
      const json  = {
        videoID:   video.videoId,
        cover:     video.thumbnail.thumbnails[0].url,
        name:      video.title.runs[0].text,
        artist:    video.ownerText.runs[0].text,
        lengthInt: null,
        lengthStr: video.thumbnailOverlays[0].thumbnailOverlayTimeStatusRenderer.text.simpleText
      };
      const split    = json.lengthStr.split(':');
      json.lengthInt = Number(split[0] * 60) + Number(split[1]);
      results.push(json);
    }
  }

  return results;
}

scrape(url + query).then(result => console.log(result));
