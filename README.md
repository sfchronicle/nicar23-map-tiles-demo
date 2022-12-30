# NICAR 2023: Open Source Vector Maps for Newsrooms

[Link to presentation deck](https://docs.google.com/presentation/d/1H9S_1h4-ezYZ0ixaUG_zPne1ufkk3prai-XXOKA1Pxc/edit#slide=id.g1c296784c18_0_349)

## Tile generation steps

1. Clone this repo to a local folder, `cd` into it.
1. Install flyctl like so: `brew install flyctl` (for non-Mac: `curl -L https://fly.io/install.sh | sh`)
1. Connect to an account: `fly auth signup`
1. Start the launch (but don't deploy yet): `fly launch`
1. Create a volume to hold our vector data: `fly volumes create app_data --size 85 --no-encryption` (85 GB will fit the whole world, but you can do 35 GB if you only need North America or 10 GB if you only need one state)
1. Go into the Fly.io admin and scale up your server! Make the adjustment at https://fly.io/apps/YOURAPPNAME/scale, "dedicated-cpu-4x" with 32 GB memory should do it. Note that generating "planet" tiles can take over an hour. But now you have data for the whole planet! We live in incredible times.
1. Deploy your app from the terminal! `fly deploy`
1. You can monitor the deploy here: https://fly.io/apps/YOURAPPNAME/monitoring
1. Once the deploy is finished, you can visit your served tiles here: https://YOURAPPNAME.fly.dev/
1. Don't forget to scale your server back down! We only need the beefy hardware for tile generation, and it can cost a couple dollars if you forget to scale down. Return to https://fly.io/apps/YOURAPPNAME/scale, "shared-cpu-1x" with 512 MB works great.

## Getting tiles off of Fly.io and onto your computer

Simon Willison also [has instructions for this](https://til.simonwillison.net/fly/scp), but these worked for me:

1. `fly ssh issue --agent`, enter your details.
1. In a new terminal tab: `fly proxy 10022:22`
1. In original terminal tab: `fly ssh console`
1. Inside the console, run `apt-get update && apt-get install openssh-client -y && exit`
1. Now, from your local, run `scp -P 10022 root@localhost:/data/tennessee.mbtiles ~/tennessee.mbtiles` (replace with the actual name of your tiles)
