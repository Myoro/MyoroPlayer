const axios    = require("axios");
const cheerio  = require("cheerio");

async function scrape(url) {
  let response = await axios.get(url + "/recommended");
  let $        = cheerio.load(response.data);

  // Gathering the song titles & hrefs
  const result = []; 
  $("body noscript").each((index, noScript) => {
    if(!$(noScript).text().includes("JavaScript is disabled")) {
      const $noScriptContent = cheerio.load($(noScript).html());

      $noScriptContent("section article").each((index, article) => {
        const $articleContent = cheerio.load($(article).html());

        result.push({
          url:       "https://soundcloud.com" + $articleContent('a').eq(0).attr("href"),
          title:     $articleContent('a').eq(0).text(),
          artist:    null,
          album:     null,
          cover:     null,
          lengthStr: null,
          lengthInt: null
        });
      });
    }
  }); 

  // Gathering the rest of the song's information that we need
  for(let i = 0; i < result.length; i++) {
    response = await axios.get(result[i].url);
    $        = cheerio.load(response.data);
    $("body script").each(async (index, script) => {
      const match = $(script).text().match(/window\.__sc_hydration\s*=\s*(\[.*?\]);/);
      if(match) {
        const treasure  = JSON.parse(match[1]);
        const artist    = treasure[7].data.publisher_metadata.artist;
        const album     = treasure[7].data.publisher_metadata.album_title;
        let   lengthInt = treasure[7].data.full_duration.toString();
              lengthInt = (lengthInt.length === 6) ? lengthInt.substr(0, 3) : lengthInt.substr(0, 2);
        result[i].artist    = artist ? artist : null;
        result[i].album     = album ? album : null;
        result[i].cover     = treasure[7].data.artwork_url;
        result[i].lengthInt = lengthInt;
        result[i].lengthStr = Math.floor(lengthInt / 60) + ':' + (lengthInt % 60).toString().padStart(2, '0');
      }
    });
  }

  return result;
}

module.exports = scrape;
