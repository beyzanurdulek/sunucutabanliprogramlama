<%
' global.asp
' Baby Web için: diziyi bir kez oluşturuyoruz.
' DİKKAT: Burada DIM KULLANMIYORUZ ki başka sayfalarda tekrar DIM edebilelim.

If Not IsArray(kitaplar) Then
    ReDim kitaplar(2)

    kitaplar(0) = "Sefiller;Victor Hugo;1862;Roman"
    kitaplar(1) = "Suç ve Ceza;Fyodor Dostoyevski;1866;Roman"
    kitaplar(2) = "Simyacı;Paulo Coelho;1988;Roman"
End If
%>
