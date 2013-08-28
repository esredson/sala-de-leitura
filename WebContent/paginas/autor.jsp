
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
  
 <t:main>
    <script language="javascript">
        
    $(document).ready(function() {
           
        $( "#dialog-form" ).dialog({
      		autoOpen: false,
			resizable: false,
      		height:200,
     		width: 350,
      		modal: true,
      		buttons: {
       			"Ok": function() {
					var nome = $("#nome"), id = $("#id");						
					if (nome.val().length != 0){		
						alert($(this).data('retorno'));
						$.getJSON("./autor/incluir",{"nome": nome.val()}, function(result){
							//alert("Veio: "+ JSON.stringify(result, null, 4));
				    		var fn = $( "#dialog-form" ).data('retorno');
							fn([result.nome, result.id]);
							$( "#dialog-form" ).dialog( "close" );
						  })
					} else {
						nome.addClass( "ui-state-error" );
						//$( ".validateTips" ).addClass( "ui-state-highlight" );
					}
          		},
        		"Cancelar": function() {
          			$( this ).dialog( "close" );
          		}
      		},
			open: function(){
				$("#nome").val($(this).data('reg')[0]);
				$("#id").val($(this).data('reg')[1]);
			},
     		close: function() {
        		var allFields = $( [] ).add($("#nome"));
				allFields.val("").removeClass( "ui-state-error" );
				$(this).data('reg', ['','']);
      		}
    	});

    	$( "#incluir-autor" )
   		.button({icons: { primary: "ui-icon-plusthick"}})
   	 	.click(function() {
      		$( "#dialog-form" ).data('retorno', fnIncluido).dialog( "open" );
    	});
 
        $('#tabela').dataTable( {
            "bPaginate": true,
            "iDisplayLength": 10,
			"bProcessing": true,				//mostra um processing indicator
    		"bJQueryUI": true,					//temas
    		"oLanguage": {
    			"sProcessing":   "Processando...",
    			"sLengthMenu":   "Mostrar _MENU_ registros",
    			"sZeroRecords":  "N�o foram encontrados resultados",
    			"sInfo":         "Mostrando de _START_ at� _END_ de _TOTAL_ registros",
    			"sInfoEmpty":    "Mostrando de 0 at� 0 de 0 registros",
    			"sInfoFiltered": "(filtrado de _MAX_ registros no total)",
    			"sInfoPostFix":  "",
    			"sSearch":       "Buscar:",
    			"sUrl":          "",
    			"oPaginate": {
    				"sFirst":    "Primeiro",
    				"sPrevious": "Anterior",
    				"sNext":     "Seguinte",
    				"sLast":     "�ltimo"
    			}
    		}, 
			"fnCreatedRow": function( nRow, aData, iDataIndex ) {
				var id = this.fnGetData(nRow)[1];
				nRow = $(nRow);
				nRow.mouseover(function(){
					var thatContainer = $("[name='icone']").parent();
					var thisContainer = $(this).find("[name='icones']");
					if (thisContainer.html() == ""){
						thisContainer.css("visibility", "visible").html(thatContainer.html());
						thatContainer.html("");
					} else {
						thisContainer.css("visibility", "visible");
					}
				});
				nRow.mouseout(function(){
					$(this).find("[name='icones']").css("visibility", "hidden");
				});
				nRow.attr('id', id);
			},
			"aaData": [
			<c:forEach var="autor" items="${autores}">
				{
					"0": "${autor.nome}",
					"1": "${autor.id}"
				},
			</c:forEach>
			],
			"aoColumnDefs": [
				{
					"mRender": function ( data, type, row ) {
						return data + "<div name='icones' style='display: inline-block'></div>";
					},
					"aTargets": [ 0 ]
				},
				{ 
					"bVisible": false, 
					"aTargets": [ 1 ] 
				}
			]	
        } );
        $('#tabela_length').css("display", "none");
        
        $(this).tooltip();

		$("#mensagem").hide();
        
        $( "#accordion" ).accordion({
     		heightStyle: "content"
    	});
    } );
	
	function fnExcluir(jRow){
		var icones = jRow.find("[name='icones']");
		if (icones.html() != "")
			$("#firstContainer").html(icones.html());
		$('#tabela').dataTable().fnDeleteRow(jRow[0], null, true);
		msg("Autor exclu�do com sucesso");
	};
	
	function fnExcluido(){
	}
		
	function fnAlterar(jRow){
		$( "#dialog-form" )
		.data('retorno', fnAlterado)
		.data('reg', $('#tabela').dataTable().fnGetData(jRow[0]))
		.dialog( "open" );
	}
	
	function fnAlterado(reg){
		var dt = $('#tabela').dataTable();
		var jRow = $("#"+reg[1]);
		
		var icones = jRow.find("[name='icones']");
		if (icones.html() != "")
			$("#firstContainer").html(icones.html());
		
		dt.fnUpdate(reg, jRow[0]);			
		msg("Autor alterado com sucesso");
	}
	
	function fnIncluir(){
	}
		
	function fnIncluido(reg){
		$('#tabela').dataTable().fnAddData(reg);			
		msg("Autor inclu�do com sucesso");
	}
	
	function msg(txt){
		$("#mensagem #cerne").html(txt);
		$("#mensagem").fadeIn(1000, function(){
			setTimeout("$('#mensagem').fadeOut(1000);",1000);
		});
	}
		
    </script>
    <div style="background: #261803 url(stylesheets/swanky-purse/images/ui-bg_diamond_8_261803_10x8.png) 50% 50% repeat; position: fixed; top: 0pt; left: 0; width: 100%; height: 100pt;">
    	<div style="width: 150pt; height: 100%;">
    		<img src="images/livros.jpg" style="width: 100%; height: auto" />
    	</div>
    	<div style="padding-left: 5pt; padding-top: 5pt; position: fixed; top:0pt; left: 150pt; height: 100pt; width: 300pt; color: #f8eec9; font-size: 38pt; font-family: Georgia,Verdana,Arial,sans-serif;}">Sala de <br/>Leitura</div>
    	<div style="padding-left: 10pt; padding-top: 10pt; position: fixed; top:0pt; right: 10pt; height: 100pt; width: 300pt; color: #f8eec9; font-size: 12pt;">
    	<p align="right">Patr�cia de Mello Tavares da Rocha | <b>Sair</b></p>
    	<p align="right">Col�gio Estadual S�o Bernardo</p>
    	</div>
	</div>
	<div style="background: #261803 url(stylesheets/swanky-purse/images/ui-bg_diamond_8_261803_10x8.png) 50% 50% repeat; position: fixed; top: 100pt; left: 0; width: 150pt; height: 100%;">
		<div id="accordion" >
  			<h3>Consultas</h3>
  			<div>
  			 	<h4 align="right"><a href="#" style="text-decoration: none">Empr�stimos</a></h4>
  			 	<h4 align="right"><a href="#" style="text-decoration: none">Localiza��es</a></h4>
  			 	<h4 align="right"><a href="#" style="text-decoration: none">Livros</a></h4>
  			 	<h4 align="right"><a href="#" style="text-decoration: none; color: white; !important;">Autores</a></h4>
  			 	<h4 align="right"><a href="#" style="text-decoration: none">G�neros</a></h4>
  			 	<h4 align="right"><a href="#" style="text-decoration: none">Alunos</a></h4>
  			</div>
  			<h3>Gr�ficos</h3>
  			<div>
    			<h4 align="right"><a href="#" style="text-decoration: none">Melhores leitores</a></h4>
 			</div>
 			<h3>Administra��o</h3>
  			<div>
    			<h4 align="right"><a href="#" style="text-decoration: none">Usu�rios</a></h4>
    			<h4 align="right"><a href="#" style="text-decoration: none">Escolas</a></h4>
 			</div>
		</div>
	</div>
	<div style="padding-left: 30pt; padding-top: 20pt; position: fixed; top: 100pt; left: 150pt; height: 100%; width: 100%;">
	
    <button id="incluir-autor">Novo autor</button>
	<div id="mensagem" class="ui-state-highlight ui-corner-all" style="left: 400px; margin-top: 0px; padding: 0 .7em; display: inline-block;">
		<p><span class="ui-icon ui-icon-info" style="float: left; margin-right: .3em;"></span>
		<span id="cerne"></span></p>
	</div>
    <br/>
    <br/>
    <table id="tabela">
    	<thead>
    		<tr>
    			<th>Nome</th>
				<th></th>
    		</tr>
    	</thead>
    	<tbody>
            <tr>
            	<td>
                </td>
				<td>
                </td>
            </tr>
        </tbody>
    </table>
    </div>
	
    <div id="dialog-form" title="Novo Autor"> 
		<!--<p class="validateTips">Campo obrigat�rio</p>-->
		<br/>
  		<form>
  			<fieldset>
   				<label for="nome">Nome</label>
    			<input type="text" name="nome" id="nome" class="text ui-widget-content ui-corner-all" />
				<input type="hidden" name="id" id="id" />
  			</fieldset>
  		</form>
	</div>
	
	<div name="icones" id="firstContainer">
		<!--&nbsp;<a name="icone" href="#" title="Buscar" style="display: inline-block;" class="ui-state-default ui-corner-all ui-icon ui-icon-search" onclick="row[1]"></a>-->
		&nbsp;<a name="icone" id="editar" href="#" title="Editar"  style="display: inline-block;" class="ui-state-default ui-corner-all ui-icon ui-icon-pencil" onclick="fnAlterar($(this).parent().parent().parent())"></a>
		<a name="icone" href="#" id="excluir" title="Excluir" style="display: inline-block; " class="ui-state-default ui-corner-all ui-icon ui-icon-close" onclick="fnExcluir($(this).parent().parent().parent())"></a>
	</div>
</t:main>