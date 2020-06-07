import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uniprintgestao/app/shared/graph/usuario.dart';

class CabecalhoDetalhesUsuario extends StatelessWidget {
  final Usuario usuario;
  final bool carregar;

  const CabecalhoDetalhesUsuario(this.usuario, this.carregar);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _getProfile(),
      height: 100,
    );
  }

  Widget _getProfile() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(usuario.url_foto ??
                'https://www.pnglot.com/pngfile/detail/192-1925683_user-icon-png-small.png')),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  usuario?.pessoa?.nome,
                  overflow: TextOverflow.clip,
                  maxLines: 2,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
              Expanded(child: Text(usuario?.email))
            ],
          ),
        )
      ],
    );
  }
}
