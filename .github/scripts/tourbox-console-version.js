// Usage: node tourbox-console-version.js

const playwright = require('playwright');

const url = 'https://www.tourboxtech.com/jp/downloads';

(async () => {
    const browser = await playwright.chromium.launch();
    const context = await browser.newContext();
    const page = await context.newPage();
    await page.goto(url);
    await page.waitForSelector('a[href*="TourBoxInstall"]', {
        state: 'visible',
        timeout: 60_000
    });
    const downloadURL = await page.$eval('a[href*="TourBoxInstall"]', el => el.href);
    const version = downloadURL.match(/TourBoxInstall(\d+\.\d+\.\d+)\.zip/)[1];
    console.log(version);
    await browser.close();
})();
