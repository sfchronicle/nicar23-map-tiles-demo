import React, {useEffect} from 'react'
import maplibregl from 'maplibre-gl'
import 'maplibre-gl/dist/maplibre-gl.css'

const IndexPage = () => {

  useEffect(() => {
    // Our own homemade style
    const style = "https://nicar23-map-tiles.fly.dev/styles/blue_tennessee/style.json"

    // Instantiate the map - heck yeah, it's free!
    const map = new maplibregl.Map({
      container: 'map', 
      style: style,
      center: [-86.7816, 36.1627], 
      zoom: 12
    });

    map.on('load', () => {
      map.addSource('subcounty', {
        type: 'vector',
        url: 'https://nicar23-map-tiles.fly.dev/data/tn_county_sub_tiger.json'
      })
      map.addLayer({
        'id': 'subcounty',
        'source': 'subcounty',
        'source-layer': 'tn_county_sub_tiger',
        'type': 'line',
        'paint': {
          'line-color': 'red',
          'line-width': 2,
          'line-dasharray': [2, 2]
        }
      }, 'admin_sub')
    })
  })

  return (
    <main>
      <h1>NICAR 2023: Open Source Vector Maps for Newsrooms</h1>
      <div id='map' style={{'height': '500px'}}></div>
    </main>
  )
}

export default IndexPage
