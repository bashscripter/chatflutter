import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  TextComposer(this.sendMessage);

  final Function({String text, File imgFile}) sendMessage;

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  final TextEditingController _controller = TextEditingController();

  bool _isComposing = false;

  void _reset() {
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: <Widget>[
            //botao da camera
            IconButton(
                icon: Icon(Icons.photo_camera),
                onPressed: () async {
                  final File imgFile =
                      await ImagePicker.pickImage(source: ImageSource.camera);
                  if (imgFile == null) return;
                  widget.sendMessage(
                      imgFile:
                          imgFile); //especificando que aqui passa apenas imagens
                }),

            Expanded(
                child: TextField(
              controller: _controller,
              decoration:
                  InputDecoration.collapsed(hintText: 'Escreva sua mensagem'),
              //Quando haver mudanças
              onChanged: (text) {
                setState(() {
                  //para verificar se esta compondo o texto
                  _isComposing = text.isNotEmpty;
                });
              },

              ////quando tocar no teclado para enviar a mensagem
              onSubmitted: (text) {
                widget.sendMessage(text: text);
                _reset();
              },
            )),

            //botao de enviar
            IconButton(
                icon: Icon(Icons.send),
                onPressed: _isComposing
                    ? () {
                        widget.sendMessage(
                            text: _controller
                                .text); //especificando que aqui passa apenas textos
                        _reset();
                      }
                    : null)
          ],
        ));
  }
}
