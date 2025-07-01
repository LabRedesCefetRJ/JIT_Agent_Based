myUUID("2d3f8133-c4dd-47fe-be75-49494fd5f06d").
gateway("skynet.chon.group", 5500).					//public server
chainServer("http://testchain.chon.group:9984/").	//public server
cryptocurrency("0a73dc0f45cc7b4584d07385c114ff54a78f9d341be798e32c12277b3a287b1b").

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
	.velluscinum.walletContent(S,P,Q,wallet).		//https://github.com/chon-group/Velluscinum/wiki/walletContent-Internal-Action

+!consultarProduto(Tag)[source(Cliente)]: produtoValor(Tag,Value) <-
	?myWallet(Priv,PublicKey);
	.print("Enviando cotação de preço...");
	.sendOut(Cliente, tell, cotacao(Tag,Value,PublicKey)).

+!comprar(Qtd,Produto,CodPix)[source(Cliente)]: chainServer(S) & myWallet(P,Q) <-
	?ultimoPedido(N);
	NrPedido=N+1;
	-+ultimoPedido(NrPedido);
	.print("Recebi pedido ", NrPedido);
	.velluscinum.stampTransaction(S,P,Q,CodPix);	//https://github.com/chon-group/Velluscinum/wiki/stampTransaction-Internal-Action
	.sendOut(Cliente, achieve, recebimento(Qtd,Produto)).
