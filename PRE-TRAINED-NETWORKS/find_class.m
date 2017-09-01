function class=find_class(nome_arquivo)


	
        %nome_arquivo=cell2mat(nome_arquivo);
	indice1=strfind(nome_arquivo, '/');
	
        nome_arquivo=nome_arquivo(indice1(end)+1:end);
	indice=strfind(nome_arquivo, '_');
	
        name=nome_arquivo(1:indice-1);

	if (strcmp(name,'AcquaMarina')==1)
		class=1;
	end

	if (strcmp(name,'AzulCapixaba')==1)
		class=2;
	end
	
	if (strcmp(name,'AzulPlatino')==1)
		class=3;
	end

	if (strcmp(name,'BalticBrown')==1)
		class=4;
	end

	if (strcmp(name,'BiancoCristal')==1)
		class=5;
	end
	
	if (strcmp(name,'BiancoSardo')==1)
		class=6;
	end
	
	if (strcmp(name,'BluePearl')==1)
		class=7;
	end

	if (strcmp(name,'DakotaMahogany')==1)
		class=8;
	end

	if (strcmp(name,'GialloAntico')==1)
		class=9;
	end

	if (strcmp(name,'GialloNapoletano')==1)
		class=10;
	end

	if (strcmp(name,'GialloSCecilia')==1)
		class=11;
	end

	if (strcmp(name,'GialloVeneziano')==1)
		class=12;
	end

	if (strcmp(name,'KashmirGold')==1)
		class=13;
	end

	if (strcmp(name,'NeroAfrica')==1)
		class=14;
	end

	if (strcmp(name,'ParadisoBash')==1)
		class=15;
	end

	if (strcmp(name,'ParadisoClassico')==1)
		class=16;
	end

	if (strcmp(name,'RosaMoncao')==1)
		class=17;
	end

	if (strcmp(name,'RosaPorrino')==1)
		class=18;
	end

	if (strcmp(name,'RossoMulticolor')==1)
		class=19;
	end

	if (strcmp(name,'SkyBrown')==1)
		class=20;
	end

	if (strcmp(name,'VerdeBahia')==1)
		class=21;
	end

	if (strcmp(name,'VerdeMarino')==1)
		class=22;
	end

	if (strcmp(name,'VerdeMing')==1)
		class=23;
	end

	if (strcmp(name,'VerdeOliva')==1)
		class=24;
	end

	if (strcmp(name,'Violetta')==1)
		class=25;
	end

end
