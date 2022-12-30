# NICAR 2023: Open Source Vector Maps for Newsrooms

[Link to presentation deck](https://docs.google.com/presentation/d/1H9S_1h4-ezYZ0ixaUG_zPne1ufkk3prai-XXOKA1Pxc/edit#slide=id.g1c296784c18_0_349)

## Tile generation steps (for Mac OS)

1. Clone this repo to a local folder, `cd` into it
1. Install flyctl like so: `brew install flyctl`
1. Connect to an account: `fly auth signup`
1. Start the launch (but don't deploy yet): `fly launch`
1. Create a volume to hold our vector data: `fly volumes create app_data --size 85 --no-encryption` (85 GB will fit the whole world, but you can do 35 GB if you only need North America or 10 GB if you only need one state)
1. Go into the Fly.io admin and scale up your server! Make the adjustment at https://fly.io/apps/YOURAPPNAME/scale, "dedicated-cpu-4x" with 32 GB memory should do it.
1. Deploy your app from the terminal! `fly deploy`
1. You can monitor the deploy here: https://fly.io/apps/YOURAPPNAME/monitoring
1. Once the deploy is finished, you can visit your served tiles here: https://YOURAPPNAME.fly.dev/
1. Don't forget to scale your server back down! We only need the beefy hardware for tile generation. Return to https://fly.io/apps/YOURAPPNAME/scale, "shared-cpu-1x" with 512 MB works great.