# NICAR 2023: Open Source Vector Maps for Newsrooms

[Link to presentation deck](https://docs.google.com/presentation/d/1H9S_1h4-ezYZ0ixaUG_zPne1ufkk3prai-XXOKA1Pxc/edit#slide=id.g1c296784c18_0_349)

## Tile generation steps

1. Clone this repo to a local folder, `cd` into it.
1. Install flyctl like so: `brew install flyctl` (for non-Mac: `curl -L https://fly.io/install.sh | sh`)
1. Connect to an account: `fly auth signup`
1. Start the launch (but don't deploy yet): `fly launch`
1. Create a volume to hold our vector data: `fly volumes create app_data --size 100 --no-encryption` (85 GB will fit the whole world, adding some extra GB for headroom)
1. Go into the Fly.io admin and scale up your server! Make the adjustment at https://fly.io/apps/YOURAPPNAME/scale, "dedicated-cpu-4x" with 32 GB memory should do it. Note that generating "planet" tiles can take over an hour. But now you have data for the whole planet! We live in incredible times.
1. Deploy your app from the terminal! `fly deploy`
1. You can monitor the deploy here: https://fly.io/apps/YOURAPPNAME/monitoring
1. Once the deploy is finished, you can visit your served tiles here: https://YOURAPPNAME.fly.dev/
1. Don't forget to scale your server back down! We only need the beefy hardware for tile generation, and it can cost a couple dollars if you forget to scale down. Return to https://fly.io/apps/YOURAPPNAME/scale, "shared-cpu-1x" with 512 MB works great.

## Getting tiles off of Fly.io and onto your computer

Simon Willison also [has instructions for this](https://til.simonwillison.net/fly/scp), but these worked for me:

1. From the project's working directory (pwd), run `fly ssh issue --agent`, enter your details.
1. In a new terminal tab (still in pwd): `fly proxy 10022:22`
1. In original terminal tab: `fly ssh console`
1. Inside the console, run `apt-get update && apt-get install openssh-client -y && exit` (if you see `exec: "scp": executable file not found in $PATH` as an error, that means you need to run this line again)
1. Now, from your local, run `scp -P 10022 root@localhost:/data/tennessee.mbtiles ~/tennessee.mbtiles` (replace tennessee with the actual name of your tiles)

The .mbtiles file should now exist in the location you told it to download to.

## Convert large data files to servable mbtiles using Tippecanoe

1. Install Tippecanoe using `brew install tippecanoe`
1. Run using `tippecanoe -z14 --drop-densest-as-needed --base-zoom=14 -o tn_county_sub_tiger.mbtiles tn_county_sub_tiger.geojson --force`

`-z14` is usually sufficient, but if you want to get really granular you can go `-z16` -- this will increase the size of the .mbtiles file substantially but it won't mean a bigger download for our readers! That's ~ tile magic ~ (really it's just because readers only download what they zoom to).

Important note: Whatever your "output" name is in the tippecanoe function above, that will be your "source-layer" when including the data using Maplibre. Avoid hyphens and spaces since these will be removed. 

```
map.addSource('example-source', {
  'type': 'vector',
  'tiles': [
    'https://nicar23-map-tiles.fly.dev/data/tn_county_sub_tiger/{z}/{x}/{y}.pbf'
  ]
})
map.addLayer(
  {
    'id': 'example-layer',
    'type': 'vector',
    'source': 'example-source',
    'source-layer': 'tn_county_sub_tiger', // NOTE: This must match your uploaded source Layer ID exactly
    'type': 'fill',
    'paint': {
      'fill-color': '#00ffff',
      'fill-opacity': 1
    }
  },
  'admin_sub' // Use this to specify what layer this one should order under
)
```

## What happens when /mbtiles exceeds 8GB?

The starter Fly.io volume that the Docker container loads on currently has 8GB of available space. This is different from the persistent storage volume. Theoretically, if the contents of the /mbtiles folder were to exceed 8GB, the deploy would fail. Since data sets can be large, this could easily happen.

If you use this setup for the long run, it would be good practice to `scp` your mbtiles directly onto persistent storage which can be expanded to be as large as you need. For that, you'll want to do the reverse of the process outlined in `Getting tiles off of Fly.io and onto your computer` section above. These instructions assume you have already issued a certificate and installed `openssh-client` from that section.

1. Use the terminal to [extend your persistent volume](https://fly.io/docs/flyctl/volumes-extend/) to whatever new size you need to accommodate the new files
1. In a new terminal tab (still in your project working directory): `fly proxy 10022:22`
1. In original terminal tab: `scp -P 10022 ~/tennessee.mbtiles root@localhost:/data/mbtiles/tennessee.mbtiles` (replace tennessee with the actual name of your tiles)
