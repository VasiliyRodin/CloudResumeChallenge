(async function bumpAndShowUnique(){
    try{
        const element = document.getElementById('visit_count');
        if (!element) return;
        const base = 'https://xr5fwzutcc.execute-api.us-east-1.amazonaws.com/prod';
        const seen = localStorage.getItem("vr-site-seen")// on the first run through this is false.
        const response = await fetch(`${base}/hit`, seen //fetch takes the url(required) and an option variable which here is being determined but the if seen is true
            ? {method: "GET"}
            : {
                method: "POST",
                headers: {"Content-Type":"application/json"},
                body: "{}"
            }
        )
        const data = await response.json()// wait for the response above, expect json.
        element.textContent = Number(data.total_views ?? 0);
        if(!seen) localStorage.setItem("vr-site-seen","1");        
    }catch(e){
        console.log("view count didn't work",e);
    }
})();