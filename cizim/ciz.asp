<!--#include file="db.asp"-->
<html>
<head>
<meta charset="utf-8">
<title>Çizim Sonucu</title>

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
    color: #003366;
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
    background: #3399ff;     /* MAVİ */
    color: white;
    border: none;
    border-radius: 4px;
}

#kontrol button:hover {
    background: #1a75d1;     /* KOYU MAVİ */
}
</style>
</head>

<body>

<div id="baslik">
    Çizim Sonucu
</div>

<div id="canvasContainer">
    <canvas id="alan"></canvas>

    <div id="kontrol">
        <button onclick="tekrarCiz()">Tekrar Çizim Yap</button>
    </div>
</div>

<script>
let canvas = document.getElementById("alan");
let ctx = canvas.getContext("2d");

/* Canvas boyutu */
function resizeCanvas() {
    canvas.width = Math.floor(window.innerWidth * 0.9);
    canvas.height = Math.floor(window.innerHeight * 0.7);
}
resizeCanvas();

window.addEventListener("resize", resizeCanvas);

/* Çizim ayarları */
ctx.font = "14px Arial";
ctx.strokeStyle = "#333";
ctx.fillStyle = "red";

/* Şekli çiz */
ctx.beginPath();

<%
Dim rs, sira
Set rs = conn.Execute("SELECT * FROM Noktalar ORDER BY sira")
sira = 1

Do While Not rs.EOF
%>
    var x = <%=rs("x")%>;
    var y = <%=rs("y")%>;

    if (<%=sira%> == 1) {
        ctx.moveTo(x, y);
    } else {
        ctx.lineTo(x, y);
    }

    // Nokta
    ctx.fillRect(x - 3, y - 3, 6, 6);

    // Numara
    ctx.fillText("<%=sira%>", x + 8, y - 8);

<%
    sira = sira + 1
    rs.MoveNext
Loop
%>

ctx.closePath();
ctx.stroke();

/* Tekrar çizime gönder */
function tekrarCiz() {
    window.location.href = "index.asp";
}
</script>

</body>
</html>


