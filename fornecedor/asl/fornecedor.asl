myUUID("2d3f8133-c4dd-47fe-be75-49494fd5f06d").
gateway("10.0.3.9", 5500).

chainServer("http://testchain.chon.group:9984/").
cryptocurrency("cfc4c2a63e888523249ea3d0fba1575106b944292b3ae2d6e3a0f880ca86442c").

produtoValor(286331153,33).
produtoValor(572662306,32).
produtoValor(858993459,31).

ultimoPedido(0).

!start.

+!start: chainServer(S) & gateway(Gateway,Port) & myUUID(UUID) <- 
	.print("Trying to connect to ", Gateway);
	.connectCN(Gateway,Port,UUID);
	.velluscinum.loadWallet(myWallet);
	.wait(myWallet(P,Q));
	.velluscinum.walletContent(S,P,Q,wallet);
	//.velluscinum.stampTransaction("http://testchain.chon.group:9984/","8Gj9WTcEWMNmmbE2mdFRakbVotDpPCE3Jsjuz7fE1pDT","7mZEAyhV9ZT8JEepk2fPxm4AyMj2sDuVgtqS6CEgSgjy","640299b17e8c44d94a89168fbb33d284dd26b3cb4dc6c70a9455420429c1f995").
		//.velluscinum.stampTransaction(S,P,Q,Payment);
.

+!consultarProduto(Tag)[source(Cliente)]: produtoValor(Tag,Value) <-
	?myWallet(Priv,PublicKey);
	.print("Enviando cotação de preço...");
	.sendOut(Cliente, tell, cotacao(Tag,Value,PublicKey)).

+!comprar(Qtd,Produto,CodPix)[source(Cliente)]: chainServer(S) & myWallet(P,Q) <-
	?ultimoPedido(N);
	NrPedido=N+1;
	-+ultimoPedido(NrPedido);
	.print("Recebi pedido ", NrPedido);
	.velluscinum.stampTransaction(S,P,Q,CodPix);
	.sendOut(Cliente, achieve, recebimento(Qtd,Produto)).
