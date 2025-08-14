# CloudResumeChallenge

Vasiliy Rodin Devops Resume Challenge:
Following the work steps from: 
https://cloudresumechallenge.dev/docs/the-challenge/aws/

This project has exposed me to modern cicd practices. Creating my own pipelines for code deployment, deploying a static website through autmation. 

    So far:
        Created a resume template with html and some css thats not complete on purpose.
        Deployed an S3 bucket with a IAM user that only manages S3 buckets with terraform. 
        Use Terraform to deploy the original site files.(This could probably have been done with github actions seperatly)
        Created a github actions workflow to update the s3 bucket with latest code without having to manually deploy the site files(.github/workflows/deploy-site.yml)
        I have deployed cloud front manually and exposed my site through https.

    Todo:
        Create terraform workflow so that I don't have to manually apply terraform configs.
        Have my website be accessible through https using CloudFront.
        Point my url vasiliyrodin.com to this site through route 53.
        Add some javascript that counts how many time the page has been accessed (for now just display it in the terminal)


HTTPS Through cloudfront.
    I have to terminate public access to the s3 bucket.
    Only allow cloudfront to access the bucket.
    Run everything through cloudfront.

    What I had to do to get it working manually through console.
    Bucket -> Permissions -> Turn off all 4 public access
           -> Properties -> Turn off static webhosting

    CloudFront
            -> Create distribution
                ->Point to s3 origin
                ->Leave origin path
                ->Use recommended settings (Redirect HTTP to HTTPS)
                ->Allow private s3 bucket access
                
            -> Once created
                ->General Settings -> root object -> index.html
                ->Origins
                    ->Edit Origins
                    ->Copy Policy
                    ->Add it the buckets s3 permissions
    Now I need to do this in Terraform.
