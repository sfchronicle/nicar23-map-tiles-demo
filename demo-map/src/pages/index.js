// @refresh reset
import React, {useEffect} from 'react'
import maplibregl from 'maplibre-gl'
import 'maplibre-gl/dist/maplibre-gl.css'

const IndexPage = () => {

  useEffect(() => {
    // Our own homemade style
    const style = ""

    // Instantiate the map - heck yeah, it's free!
    const map = new maplibregl.Map({
      container: 'map', 
      style: style,
      center: [-86.7816, 36.1627], 
      zoom: 12
    });
  })

  return (
    <main>
      <h1>NICAR 2023: Open Source Vector Maps for Newsrooms</h1>
      <div id='map' style={{'height': '500px', 'background': 'papayawhip'}}></div>
    </main>
  )
}

export default IndexPage
