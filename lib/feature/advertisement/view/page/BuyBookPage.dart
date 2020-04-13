import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/core/services/FireAnalytics.dart';
import 'package:altitude/core/view/BaseState.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BuyBookPage extends StatefulWidget {
  @override
  _BuyBookPageState createState() => _BuyBookPageState();
}

class _BuyBookPageState extends BaseState<BuyBookPage> {
  void buyBook() async {
    FireAnalytics().sendBuyButtonClicked();
    if (await canLaunch(BUY_BOOK)) {
      await launch(BUY_BOOK);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                SizedBox(width: 50, child: IconButton(icon: Icon(Icons.close, size: 20), onPressed: navigatePop))
              ]),
            ),
            Container(
              color: Colors.orange.withAlpha(100),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text("  Entenda de uma vez por todas porque você não consegue mudar seus hábitos.",
                  textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 20),
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 16, height: 1.15, fontFamily: "Montserrat"),
                  children: [
                    TextSpan(
                      text:
                          "\n\n  O livro “O Poder do Hábito” do autor Charles Duhigg, que foi a inspiração do Altitude, revela o ",
                    ),
                    TextSpan(text: "segredo dos hábitos", style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            " para você tomar o controle de sua vida rumo aos seus maiores desejos.\n\n  Quer aprender de vez como usar seu cotidiano para alcançar "),
                    TextSpan(text: "uma vida melhor", style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text:
                          "?\n\n  Nós, do Altitude, te trazemos a oportunidade de comprar o livro com ótimo preço e ainda ajudar a nossa plataforma a ",
                    ),
                    TextSpan(text: "mudar a vida", style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: " de muitas outras pessoas."),
                  ],
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(child: Image.asset("assets/o_poder_do_habito.jpg")),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    width: double.maxFinite,
                    child: RaisedButton(
                      color: Colors.orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      onPressed: buyBook,
                      child: Text("Compre agora",
                          style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
