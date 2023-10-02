const RLS      = require("readline-sync");
const axios    = require("axios");
const cheerio  = require("cheerio");
const prettier = require("prettier");
const fs       = require("fs");

const query = RLS.question("Enter query: ");

async function basicSearchScrape(query) {
  let response = await axios.get("https://soundcloud.com/search?q=" + query);
  let $        = cheerio.load(response.data);

  // Gathering the song titles & hrefs
  const result = [];
  $("body noscript").each((index, obj) => {
    const $noScripts = cheerio.load($(obj).html());
    const ulTags     = $noScripts("ul");

    if(ulTags.length > 0) {
      ulTags.each((index, ul) => {
        // Must be indented like this
        const badUL = `
    <li><a href="/search">Search for Everything</a></li>
    <li><a href="/search/sounds">Search for Tracks</a></li>
    <li><a href="/search/sets">Search for Playlists</a></li>
    <li><a href="/search/people">Search for People</a></li>
        `;

        // The money
        if(!$(ul).html().includes("Search for Everything")) {
          const $ulContent = cheerio.load($(ul).html());
          const aTags      = $ulContent("a");
          aTags.each((index, a) => {
            // console.log($(a).attr("href") + " --- " + $(a).html());
            const href = $(a).attr("href");
            if(href.split('/').length === 3) {
              result.push({
                url:       "https://soundcloud.com" + href,
                title:     $(a).html(),
                artist:    null,
                album:     null,
                cover:     null,
                lengthStr: null,
                lengthInt: null
              });
            }
          });
        }
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

basicSearchScrape(query).then(result => console.log(result));
