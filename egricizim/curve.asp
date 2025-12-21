<%@ Language=VBScript %>
<%
Option Explicit
Response.Charset = "utf-8"

' --------------------------
' Yardımcı: "100", "100,5", "100.5" -> Double
' --------------------------
Function ToDbl(s)
  Dim t
  t = Trim(CStr(s))
  If InStr(t, ",") > 0 And InStr(t, ".") = 0 Then
    ' TR virgül zaten ok
  ElseIf InStr(t, ".") > 0 And InStr(t, ",") = 0 Then
    ' nokta -> virgül (CDbl TR’de)
    t = Replace(t, ".", ",")
  ElseIf InStr(t, ".") > 0 And InStr(t, ",") > 0 Then
    ' 1.234,56 gibi şey gelirse sadeleştir (gerekirse)
    t = Replace(t, ".", "")
  End If
  If t = "" Then t = "0"
  ToDbl = CDbl(t)
End Function

' --------------------------
' JSON için sayı: virgülü noktaya çevir
' --------------------------
Function JsNum(n)
  JsNum = Replace(CStr(n), ",", ".")
End Function

' --------------------------
' calc=1 ise: VBScript hesapla ve JSON dön
' --------------------------
If Request.QueryString("calc") = "1" Then
  Response.ContentType = "application/json"

  Dim x(4), y(4), rx(4), ry(4)
  Dim tension, k
  Dim i
  Dim t, stepv
  Dim tt, tt2, tt3
  Dim h00, h01, h10, h11
  Dim xx, yy
  Dim firstOut

  x(1) = ToDbl(Request("x1")) : y(1) = ToDbl(Request("y1"))
  x(2) = ToDbl(Request("x2")) : y(2) = ToDbl(Request("y2"))
  x(3) = ToDbl(Request("x3")) : y(3) = ToDbl(Request("y3"))
  x(4) = ToDbl(Request("x4")) : y(4) = ToDbl(Request("y4"))

  tension = ToDbl(Request("tension"))
  k = 0.5 * (1 - tension)

  ' Verilen formüller (rx/ry)
  rx(1) = k * (x(2) - x(1)) : ry(1) = k * (y(2) - y(1))
  rx(2) = k * (x(3) - x(1)) : ry(2) = k * (y(3) - y(1))
  rx(3) = k * (x(4) - x(2)) : ry(3) = k * (y(4) - y(2))
  rx(4) = k * (x(4) - x(3)) : ry(4) = k * (y(4) - y(3))

  stepv = 0.03
  firstOut = True

  Response.Write "{""points"":["
  ' 3 parça: i=1..3
  For i = 1 To 3
    ' segment başı -> null koyacağız (JS bunu “break” gibi kullanacak)
    If firstOut Then
      firstOut = False
    Else
      Response.Write ","
    End If
    Response.Write "null"

    t = 0
    Do While t < 1.0000001
      tt = CDbl(t)
      If tt > 1 Then tt = 1

      tt2 = tt * tt
      tt3 = tt2 * tt

      h00 = (2 * tt3) - (3 * tt2) + 1
      h01 = (-2 * tt3) + (3 * tt2)
      h10 = (tt3) - (2 * tt2) + tt
      h11 = (tt3) - (tt2)

      xx = x(i) * h00 + x(i + 1) * h01 + rx(i) * h10 + rx(i + 1) * h11
      yy = y(i) * h00 + y(i + 1) * h01 + ry(i) * h10 + ry(i + 1) * h11

      Response.Write ",{""x"":" & JsNum(xx) & ",""y"":" & JsNum(yy) & "}"

      t = t + stepv
      If tt = 1 Then Exit Do
    Loop
  Next

  Response.Write "]}"
  Response.End
End If
%>

<!DOCTYPE html>
<html lang="tr">
<head>
  <meta charset="utf-8" />
  <title>4 Noktadan Geçen 3 Parçalı Eğri (ASP VBScript + Canvas)</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 0; }
    .wrap { display:flex; gap:20px; padding:10px; }
    .panel { width:280px; }
    .row { display:flex; align-items:center; margin:6px 0; }
    .row label { width:32px; }
    .row input { width:95px; padding:3px 6px; }
    .row .wide { width:130px; }
    button { padding:6px 10px; cursor:pointer; }
    canvas { border:1px solid #ddd; background:#fff; }
    .hint { font-size:12px; color:#555; margin-top:10px; line-height:1.35; }
    .ver { color:#b00; font-weight:bold; margin-bottom:10px; }
  </style>
</head>

<body onload="init();">
  <div class="wrap">
    <div class="panel">
      <div class="ver">4 Noktadan Geçen Tension Kontrollü 3 Parçalı Eğri</div>

      <div><b>Kontrol Noktaları</b></div>
      <div class="row"><label>x1</label><input id="x1" value="100"></div>
      <div class="row"><label>y1</label><input id="y1" value="200"></div>

      <div class="row"><label>x2</label><input id="x2" value="200"></div>
      <div class="row"><label>y2</label><input id="y2" value="400"></div>

      <div class="row"><label>x3</label><input id="x3" value="350"></div>
      <div class="row"><label>y3</label><input id="y3" value="200"></div>

      <div class="row"><label>x4</label><input id="x4" value="500"></div>
      <div class="row"><label>y4</label><input id="y4" value="400"></div>

      <div class="row" style="margin-top:10px;">
        <label style="width:70px;">Tension</label>
        <input id="tension" class="wide" value="-0,5">
        <button type="button" onclick="redraw()">ReDraw</button>
      </div>

    </div>

    <div>
      <canvas id="cv" width="900" height="650"></canvas>
    </div>
  </div>

<script>
  let canvas, ctx;
  let lastPt = null;

  function init(){
    canvas = document.getElementById("cv");
    ctx = canvas.getContext("2d");
    redraw();
  }

  function clearCanvas(){
    ctx.clearRect(0,0,canvas.width,canvas.height);
    ctx.strokeStyle="#eee";
    ctx.strokeRect(0.5,0.5,canvas.width-1,canvas.height-1);
  }

  function getNumStr(id){
    // server-side ToDbl hem virgül hem nokta kabul ediyor, string göndermek yeterli
    return (document.getElementById(id).value || "0").trim();
  }

  function drawControlPoint(x,y,label){
    ctx.beginPath();
    ctx.fillStyle="#000";
    ctx.arc(x,y,8,0,Math.PI*2);
    ctx.fill();

    ctx.beginPath();
    ctx.fillStyle="#fff";
    ctx.arc(x,y,3,0,Math.PI*2);
    ctx.fill();

    ctx.fillStyle="#000";
    ctx.font="16px Arial";
    ctx.fillText(label, x+10, y+6);
  }

  function plotPointAndLine(x,y){
    // nokta
    ctx.beginPath();
    ctx.fillStyle="#a000c8";
    ctx.arc(x,y,2.2,0,Math.PI*2);
    ctx.fill();

    // çizgi
    if(lastPt){
      ctx.beginPath();
      ctx.strokeStyle="#a000c8";
      ctx.lineWidth=2;
      ctx.moveTo(lastPt.x,lastPt.y);
      ctx.lineTo(x,y);
      ctx.stroke();
    }
    lastPt = {x,y};
  }

  async function redraw(){
    clearCanvas();
    lastPt = null;

    // Kontrol noktaları (client-side çizelim)
    const x1 = parseFloat(getNumStr("x1").replace(",", ".")) || 0;
    const y1 = parseFloat(getNumStr("y1").replace(",", ".")) || 0;
    const x2 = parseFloat(getNumStr("x2").replace(",", ".")) || 0;
    const y2 = parseFloat(getNumStr("y2").replace(",", ".")) || 0;
    const x3 = parseFloat(getNumStr("x3").replace(",", ".")) || 0;
    const y3 = parseFloat(getNumStr("y3").replace(",", ".")) || 0;
    const x4 = parseFloat(getNumStr("x4").replace(",", ".")) || 0;
    const y4 = parseFloat(getNumStr("y4").replace(",", ".")) || 0;

    drawControlPoint(x1,y1,"1");
    drawControlPoint(x2,y2,"2");
    drawControlPoint(x3,y3,"3");
    drawControlPoint(x4,y4,"4");

    // Server'a isteği at (VBScript hesaplayacak)
    const qs = new URLSearchParams({
      calc: "1",
      x1: getNumStr("x1"), y1: getNumStr("y1"),
      x2: getNumStr("x2"), y2: getNumStr("y2"),
      x3: getNumStr("x3"), y3: getNumStr("y3"),
      x4: getNumStr("x4"), y4: getNumStr("y4"),
      tension: getNumStr("tension")
    });

    try{
      const res = await fetch("curve.asp?" + qs.toString(), { cache: "no-store" });
      if(!res.ok) throw new Error("HTTP " + res.status);
      const data = await res.json();

      // points dizisinde null => segment kır
      for(const p of data.points){
        if(p === null){
          lastPt = null;
          continue;
        }
        plotPointAndLine(p.x, p.y);
      }
    }catch(e){
      ctx.fillStyle="#b00";
      ctx.font="16px Arial";
      ctx.fillText("Hesaplama alınamadı: " + e.message, 20, 40);
    }
  }
</script>
</body>
</html>
