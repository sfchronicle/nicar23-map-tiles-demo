#!/usr/bin/env node
const fs = require('fs')
// Create volume's mbtiles dir if it doesn't exist
const dir = '/data/mbtiles';
if (!fs.existsSync(dir)){
    fs.mkdirSync(dir);
}

// Accept arg so we can target the Plantiler-created tileset
const args = process.argv.slice(2)
const location = args[0]

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
  try {
    let path = `/${type}`
    if (type === "volume"){
      path = `/data/mbtiles`
    }
    const dir = fs.readdirSync(path)
    console.log(dir)
    for (const dirent of dir) {
      if (dirent[0] === "."){ // DO NOT include .DS_Store
        continue
      }
      if (type === "styles"){
        exportData["styles"][dirent.replace(".json", "")] = {
          "style": `/styles/${dirent}`
        }
      }
      if (type === "mbtiles"){
        exportData["data"][dirent.replace(".mbtiles", "")] = {
          "mbtiles": `/mbtiles/${dirent}`
        }
      }
      if (type === "volume"){
        exportData["data"][dirent.replace(".mbtiles", "")] = {
          "mbtiles": `/data/mbtiles/${dirent}`
        }
      }
    }
  } catch (err){
    // It's cool
  }
}

// Create final config
fileLoop("styles")
fileLoop("mbtiles")
fileLoop("volume") // Special check to see if there are any mbtiles already on the volume

console.log("EXPORTDATA", exportData)

// Write config file
fs.writeFileSync('/config.json', JSON.stringify(exportData))
