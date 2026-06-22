import { chromium } from 'playwright'
const browser = await chromium.launch()
const ctx = await browser.newContext({ viewport: { width: 1440, height: 900 }, deviceScaleFactor: 1 })
const page = await ctx.newPage()
await page.goto('http://localhost:4324/', { waitUntil: 'networkidle', timeout: 30000 })
await page.waitForTimeout(800)
await page.screenshot({ path: 'c:/D/oriz/.tmp-screenshots/janaushdhi.png', fullPage: false })
await browser.close()
console.log('ok')
