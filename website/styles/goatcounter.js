fetch("https://benson1231.goatcounter.com/counter//.json")
  .then(res => res.json())
  .then(data => {
    const el = document.getElementById("gc-total");
    if (el) {
      el.innerText = data.count;
    }
  })
  .catch(() => {
    console.log("GoatCounter fetch failed");
  });