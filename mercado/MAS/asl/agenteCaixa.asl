serialPort(ttyEmulatedPort1).
!start.

/* Plans */
+!start: serialPort(Port) <- 
	.argo.port(Port); .argo.limit(500); .argo.percepts(open).

+newTag(Time,Tag)[source(percept)] <- 
    .send(agenteEstoque,achieve,remStock(Tag)).
+port(Port,Status) <- .print("Serial port ",Port," is ",Status).