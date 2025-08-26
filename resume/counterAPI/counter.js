// run some code that sends and gathers info
(async function bumpAndShow() { //async allows you to use await
  try {
    const res = await fetch("https://xr5fwzutcc.execute-api.us-east-1.amazonaws.com/prod/hit", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: "{}"
    });//sends the empty {} request to the api gateway endpoint. await waits for the response back. 
    const data = await res.json();// reads the response and parses it as json
    document.getElementById("visit_counter").textContent = data.total_views ?? "—"; // if null show -
  } catch (e) {
    console.error("view counter failed:", e);
  }
})();//the ending () invokes the function immediately.