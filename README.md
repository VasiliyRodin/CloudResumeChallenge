# CloudResumeChallenge

#Vasiliy Rodin Devops Resume Challenge:<br>
##Following the work steps from: <br>
##https://cloudresumechallenge.dev/docs/the-challenge/aws/<br>

This project has exposed me to modern cicd practices. Creating my own pipelines for code deployment, deploying a static website through automation. 

Steps Completed:<br>
    2.HTML- create an html website.<br>
    3.Add css to the website<br>
    4.Host the website in s3(did it with terraform and github actions to update the bucket with my site files)<br>
    5.Enable https using cloud front(first manually then with terraform)
Todo:<br>
    Create terraform workflow so that I don't have to manually apply terraform configs.
    Point my url vasiliyrodin.com to this site through route 53.
    Add some javascript that counts how many time the page has been accessed (for now just display it in the terminal)

HTTPS Through cloudfront.
    I have to terminate public access to the s3 bucket.
    Only allow cloudfront to access the bucket.
    Run everything through cloudfront.

    What I had to do to get it working manually through console.
    Bucket -> Permissions -> Turn off all 4 public access
           -> Properties -> Turn off static web hosting

What I learned deploying this with terraform.
    It is not easy. So many configs to worry about that don't show up in the documentation.
    You can create the origin access (OAC) first. And assign it later (When creating this in the console you can create it on the spot and assign it)

Adding a route 53 hosted zone was not difficult.
    Creating a hosted zone with my vasiliyrodin.com url I was able to view tf output and add my ns servers to my domain provider. Now I need hook my cloudfront to use that URL.
Creating a certificate for my dns.
    I need to first create a dns certificate in tf it is aws_acm_certificate
    Validate the certificate with route 53. By assigning it to your dns record.
    Attach the certificate to your cloudfront under viewer certificate. and your alternate domain name
    Create am  A record in the route53 pointing to your cloud front distribution.