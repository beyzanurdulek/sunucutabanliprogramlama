<html>
<head>
<meta charset="utf-8">
<title>5 Nokta Seçimi</title>

<style>
html, body {
    margin: 0;
    padding: 0;
    width: 100%;
    height: 100%;
    background: #d9ecff; /* AÇIK MAVİ */
    font-family: Arial, sans-serif;
}

/* Başlık */
#baslik {
    text-align: center;
    font-size: 24px;
    font-weight: bold;
    margin-top: 20px;
    margin-bottom: 10px;
    color: #003366; /* KOYU MAVİ */
}

/* Canvas + buton kapsayıcı */
#canvasContainer {
    width: 90%;
    margin: 0 auto;
    text-align: center;
}

/* Canvas */
#alan {
    display: block;
    margin: 0 auto;
    border: 3px solid #003366;
    background: white;
}

/* Alt kontrol alanı */
#kontrol {
    margin-top: 15px;
    text-align: right;
}

/* Buton */
#kontrol button {
    padding: 10px 20px;
    font-size: 14px;
    cursor: pointer;
    background: #3399ff;
    color: white;
    border: none;
    border-radius: 4px;
}

#kontrol button:hover {
    background: #1a75d1;
}
</style>
</head>

<body>

<div id="baslik">
    5 Nokta Seçiniz
</div>

<div id="canvasContainer">
    <canvas id="alan"></canvas>

    <form method="post" action="kaydet.asp" id="kontrol" onsubmit="return kontrolEt()">
        <input type="hidden" name="veri" id="veri">
        <button type="submit">Kaydet ve Çiz</button>
    </form>
</div>

<script>
let canvas = document.getElementById("alan");
let ctx = canvas.getContext("2d");

/* Canvas boyutu (ciz.asp ile aynı) */
function resizeCanvas() {
    canvas.width = Math.floor(window.innerWidth * 0.9);
    canvas.height = Math.floor(window.innerHeight * 0.7);
}
resizeCanvas();

window.addEventListener("resize", resizeCanvas);

let noktalar = [];

/* Nokta seçimi */
canvas.addEventListener("click", function(e){

    if (noktalar.length >= 5) {
        alert("5 nokta seçildi");
        return;
    }

    let rect = canvas.getBoundingClientRect();
    let x = Math.round(e.clientX - rect.left);
    let y = Math.round(e.clientY - rect.top);

    noktalar.push({x:x, y:y});

    ctx.fillStyle = "red";
    ctx.fillRect(x - 3, y - 3, 6, 6);

    document.getElementById("veri").value =
        JSON.stringify(noktalar);
});


function kontrolEt() {
    if (noktalar.length === 0) {
        alert("Lütfen en az 1 nokta seçiniz!");
        return false; // formu gönderme
    }

    return true; // gönder
}

</script>

</body>
</html>



