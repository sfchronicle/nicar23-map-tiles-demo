#!/usr/bin/env node
const fs = require('fs')

// Accept arg so we can target the Plantiler-created tileset
const args = process.argv.slice(2)
const location = args[0]
console.log("location", location)

// Prep final config
const exportData = {
  data: {
    [location]: {
      "mbtiles": `/data/${location}.mbtiles`
    }
  },
  styles: {}
}

function fileLoop(type) {
  const path = `/${type}`
  const dir = fs.readdirSync(path)
  console.log(dir)
  for (const dirent of dir) {
    console.log("HEYOOOO", type, dirent)
    if (dirent[0] === "."){ // DO NOT include .DS_Store
      continue
    }
    if (type === "styles"){
      exportData["styles"][dirent] = {
        "style": `/styles/${dirent}/style.json`
      }
    }
    if (type === "mbtiles"){
      exportData["data"][dirent.replace(".mbtiles", "")] = {
        "mbtiles": `/mbtiles/${dirent}`
      }
    }
  }
}

// Create final config
fileLoop("mbtiles")
fileLoop("styles")

// Write config file
fs.writeFileSync('/config.json', JSON.stringify(exportData));

console.log("exportData", exportData)
