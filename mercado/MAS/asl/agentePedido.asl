fornecedor("2d3f8133-c4dd-47fe-be75-49494fd5f06d").
chainServer("http://testchain.chon.group:9984/").
myUUID("13a0014e-0980-4420-b497-587816c76c93").
gateway("skynet.chon.group", 5500).
cryptocurrency("0a73dc0f45cc7b4584d07385c114ff54a78f9d341be798e32c12277b3a287b1b").

!start.

+!start: myUUID(UUID) & gateway(Gateway,Port) <-
	.velluscinum.loadWallet(myWallet);
	.connectCN(Gateway, Port, UUID).

+!precisaDeProduto(Tag) <- +precisaDeProduto(Tag).

+precisaDeProduto(Tag): not comprandoProduto(Tag) <-
	+comprandoProduto(Tag);
	.print("Comprando produto A");
	?fornecedor(F);
	!cotacao(F,Tag).

+precisaDeProduto(Tag): comprandoProduto(Tag) <-
	.print("Compra em andamento...").

+!cotacao(Fornecedor,Produto): not cotacao(Produto,Valor,Carteira) <-
	.print("Realizando contação com o fornecedor ",Fornecedor);
	.sendOut(Fornecedor, achieve, consultarProduto(Tag));
	.random(R); .wait(5000*R);
	!cotacao(Fornecedor,Produto).

-!cotacao(Fornecedor,Produto) <- .print("Cotação recebida"); .random(R); .wait(5000*R); !comprar(Produto).

+!comprar(Produto): cotacao(Produto,Valor,Carteira)[source(Fornecedor)] <-
	?cryptocurrency(Coin);
	?chainServer(Server);
	?myWallet(MyPriv,MyPub);
	.print("Realizando o pagamento....");
	.velluscinum.transferToken(Server, MyPriv, MyPub, Coin, Carteira, 3*Valor, pix);
	.wait(pix(CodPix));
	.sendOut(Fornecedor, achieve, comprar(3,Produto,CodPix)).

+!recebimento(Qtd,Produto) <-
	.print("Aguardando entrega de ",Qtd," ",Produto).
