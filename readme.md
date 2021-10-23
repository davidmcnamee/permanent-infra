
# Permanent Infra

I use terraform to provision infrastructure for side projects, dev environments, and school work. Leaving this here as a sample for others looking to do the same.



## Credentials
Must have a `~/.aws/config` file present, in this format:
```
[default]
aws_access_key_id=The20CharacterKeyTheyGiveYou
aws_secret_access_key=The40CharacterKeyTheyGiveYou
```
> AWS Access Key can be generated from [here](https://console.aws.amazon.com/iam/home?region=us-east-1#/security_credentials$access_key)

Must also be logged in with your Google cloud account:
```bash
gcloud auth login
```
If you don't already have the `glcoud` cli installed, try `brew install --cask google-cloud-sdk` or go [here](https://cloud.google.com/sdk)
