minStock(3).
serialPort(ttyEmulatedPort0).

/* Initial goals */
!start.

/* Plans */
+!start: serialPort(Port) <- 
	.argo.port(Port); .argo.limit(500); .argo.percepts(open).
	
+newTag(Time,Tag)[source(percept)] <- !addStock(Tag).
+port(Port,Status) <- .print("Serial port ",Port," is ",Status).

+!addStock(Tag) <- ?item(Tag,Qtd); -+item(Tag,1+Qtd); !showStock(Tag).
+!remStock(Tag) <- ?item(Tag,Qtd); -+item(Tag,Qtd-1); !verifyStock(Tag).
+!showStock(Tag): item(Tag,Qtd) <- .print("Item ",Tag," = ",Qtd). 
+!verifyStock(Tag): item(Tag,Qtd) & minStock(M) & Qtd < M <-
	!showStock(Tag);
	.print("Requesting more ",Tag);
	.send(agentePedido, achieve, precisaDeProduto(Tag)).
-!verifyStock(Tag) <- !showStock(Tag).

+?item(Tag,Qtd) <- Qtd = 0; +item(Tag,Qtd).
