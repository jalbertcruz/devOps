
//COPY & PASTE CODE 1: 
let goToBottom = setInterval(() => window.scrollBy(0, 400), 1000);

//COPY & PASTE CODE 2:

clearInterval(goToBottom);
let arrayVideos = [];
console.log('\n'.repeat(50));
const links = document.querySelectorAll('a');
for (const link of links) {
if (link.id === "video-title") {
    link.href = link.href.split('&list=')[0];
    arrayVideos.push(link.title + ';' + link.href);
    console.log(link.title + '\t' + link.href);
}
}



clearInterval(goToBottom);
const links = document.querySelectorAll('a');
for (const link of links) {
if (link.id === "video-title") {
    link.href = link.href.split('&list=')[0];
    console.log(link.href);
}
}


clearInterval(goToBottom)
let arrayVideos = []
const links = document.querySelectorAll('a')
for (const link of links) {
if (link.id === "video-title") {
    link.href = link.href.split('&list=')[0]
    arrayVideos.push({title: link.title, href: link.href})
}
}
console.log(arrayVideos)

let data = {values: arrayVideos};

fetch("http:/127.0.0.1:8000/scrap/", {
  method: "POST",
  headers: {'Content-Type': 'application/json'},
  body: JSON.stringify(data)
}).then(res => {
  console.log("Request complete! response:", res)
})
