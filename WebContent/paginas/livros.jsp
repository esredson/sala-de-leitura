
<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" 
           uri="http://java.sun.com/jsp/jstl/core" %>
  
 <t:main>
    <script>
        
    $(document).ready(function() {
    	
    	var	jBotaoIncluir = $("#incluir"),
    		jModal = $("#modal"),
    		jTabela = $('#tabela'),
    		jMensagem = $("#mensagem");    		
    	
    	$("#link_livros").css("color","white");
    	
    	var incluir = function(id, nome, autor, genero){
    		$.ajax({
    			url: "./livro/incluir",
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				data: {'nome': nome, "autor": autor.id, "genero": genero.id},
				success: function(result){
					incluiuComSucesso(result.id, result.nome, result.autor, result.genero, result.status);
				}
			});
    	};
    	
    	var incluiuComSucesso = function(id, nome, autor, genero, status){
    		jModal.dialog( "close" );
    		jTabela.dataTable().fnAddData([id, nome, autor.id, autor.nome, genero.id, genero.nome, status]);			
    		msg("Livro incluído com sucesso");
    	};
    	
		var alterar = function(id, nome, autor, genero){
			$.getJSON("./livro/alterar",{"nome":nome, "id":id, "autor": autor.id, "genero": genero.id}, function(result){
				alterouComSucesso(result.id, result.nome, result.autor, result.genero, result.status);
			});
    	};
    	
    	var alterouComSucesso = function(id, nome, autor, genero, status){
    		jModal.dialog( "close" );
    		jTabela.dataTable().fnUpdate([id, nome, autor.id, autor.nome, genero.id, genero.nome, status], $("#"+id)[0]);			
    		msg("Livro alterado com sucesso");
    	}
    	
		var excluir = function(id){
    		$.getJSON("./livro/excluir",{"id":id}, function(result){
    			excluiuComSucesso([result.id]);
    		});
    	};
    	
    	var excluiuComSucesso = function(id){
    		jTabela.dataTable().fnDeleteRow($("#"+id)[0]);
    		msg("Livro excluído com sucesso");
    	}
           
    	jBotaoIncluir
    	.button({icons: { primary: "ui-icon-plusthick"}})
   	 	.click(function() {
   	 		jModal.data('acao', incluir).dialog( "open" );
    	});
    	
        jModal.dialog({
      		autoOpen: false,
			resizable: false,
      		height:"auto",
     		width: 350,
      		modal: true,
      		open: function(){
					$("#nome").val(jModal.data('nome'));
					$("#id").val(jModal.data('id'));
					autor_id = jModal.data('autor');
					$("#autor").val(invertMapping[autor_id]);
					$("#genero").val(jModal.data('genero'));
			},
			close: function() {
        		var allFields = $( [] ).add($("#nome"));
				allFields.val("").removeClass( "ui-state-error" );
				jModal.data('nome', '');
				jModal.data('id', '');
				jModal.data('autor', '');
				jModal.data('genero', '');
      		},
      		buttons: {
       			"Ok": function() {
					var acao = jModal.data('acao'),
						nome = $("#nome"), 
						id = $("#id"),
						autor = $("#autor"),
						genero = $("#genero option:selected");
					if (nome.val().length == 0){	
						nome.addClass( "ui-state-error" );
						//$( ".validateTips" ).addClass( "ui-state-highlight" );
						return;
					}
					acao(id.val(), nome.val(), {"id": autor_id, "nome": autor.val()}, {"id": genero.val(), "nome": genero.text()});
          		},
        		"Cancelar": function() {
          			jModal.dialog( "close" );
          		}
      		}
    	});
        
    	var autor_id = null;
    	var raw = [
			//<c:forEach var="autor" items="${autores}">
			{value: "${autor.id}", label: "${autor.nome}"},
			//</c:forEach>
		];
    	var source  = [ ];
    	var mapping = { };
    	var invertMapping = {};
    	for(var i = 0; i < raw.length; ++i) {
    	    source.push(raw[i].label);
    	    mapping[raw[i].label] = raw[i].value;
    	    invertMapping[raw[i].value] = raw[i].label;
    	}
    	$( "#autor").autocomplete({
            source: source,
            select: function(event, ui) {
            	autor_id = mapping[ui.item.value];
            },
        });
    	$("#autor").blur(function(){
    		if (mapping[$("#autor").val()] == 'undefined' || mapping[$("#autor").val()] == null){
        		$("#autor").val("");
        		autor_id = null;
    		}
    	});
        
        jTabela.dataTable( {
            "bPaginate": true,
            "iDisplayLength": 10,
			"bProcessing": true,				//mostra um processing indicator
    		"bJQueryUI": true,					//temas
    		"oLanguage": {
    			"sProcessing":   "Processando...",
    			"sLengthMenu":   "Mostrar _MENU_ registros",
    			"sZeroRecords":  "Não foram encontrados resultados",
    			"sInfo":         "Mostrando de _START_ até _END_ de _TOTAL_ registros",
    			"sInfoEmpty":    "Mostrando de 0 até 0 de 0 registros",
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
				var id = this.fnGetData(nRow)[0];
				var nome = this.fnGetData(nRow)[1];
				var autor = this.fnGetData(nRow)[2];
				var genero = this.fnGetData(nRow)[4];
				var jnRow = $(nRow);
				var divIcones = jnRow.find("[name = 'icones']");
         		divIcones.append("&nbsp;&nbsp;<span title=\"Editar\" style=\"display: inline-block; visibility:hidden; cursor: pointer\" class=\"ui-state-default ui-corner-all ui-icon ui-icon-pencil\"></span>");
         		divIcones.append("&nbsp;&nbsp;<span title=\"Excluir\" style=\"display: inline-block; visibility:hidden; cursor: pointer\" class=\"ui-state-default ui-corner-all ui-icon ui-icon-close\"></a>");
				divIcones.find("span:eq(0)").click(function(){
					jModal.data('acao', alterar)
		    		.data('nome', nome)
		    		.data('id', id)
		    		.data('autor', autor)
		    		.data('genero', genero)
		    		.dialog("open");
				});
				divIcones.find("span:eq(1)").click(function(){
					excluir(id);
				});
				jnRow.mouseover(function(){
					jnRow.find("div > span").css("visibility", "visible");
           		});
				jnRow.mouseout(function(){
					jnRow.find("div > span").css("visibility", "hidden");
				});
				jnRow.attr('id', id);
			},
			"aaData": [
			<c:forEach var="livro" items="${livros}">
				{
					"0": "${livro.id}",
					"1": "${livro.nome}",
					"2": "${livro.autor.id}",
					"3": "${livro.autor.nome}",
					"4": "${livro.genero.id}",
					"5": "${livro.genero.nome}",
					"6": "${livro.status}"
				},
			</c:forEach>
			],
			"aoColumnDefs": [
				{ 
					"bVisible": false, 
					"aTargets": [ 0 ] 
				},
				{
					"mRender": function ( data, type, row ) {
						return data + "<div name='icones' style='display: inline-block'></div>";
					},
					"aTargets": [ 1 ]
				},
				{ 
					"bVisible": false, 
					"aTargets": [ 2 ] 
				},
				{ 
					"aTargets": [ 3 ] 
				},
				{ 
					"bVisible": false, 
					"aTargets": [ 4 ] 
				},
				{ 
					"aTargets": [ 5 ] 
				},
				{ 
					"aTargets": [ 6 ] 
				}
			]	
        } );
    	
    	$('#tabela_length').css("display", "none");
        
        $(this).tooltip();

		jMensagem.hide();
    	
    	function msg(txt){
    		jMensagem.find("#cerne").html(txt);
    		jMensagem.fadeIn(1000, function(){
    			setTimeout("$('#mensagem').fadeOut(1000);",1000);
    		});
    	}
    	
    	 $( "#accordion" ).accordion({
      		heightStyle: "content"
     	});
    	
    } );
		
    </script>
    
	<div style="padding-left: 30pt; padding-top: 20pt; position: fixed; top: 100pt; left: 150pt; height: 100%; width: 100%;">
	
    <button id="incluir">Novo livro</button>
	<div id="mensagem" class="ui-state-highlight ui-corner-all" style=" margin-top: 0px; padding: 0 .7em; display: inline-block; position: absolute; left: 200px; top: 10px; ">
		<p><span class="ui-icon ui-icon-info" style="float: left; margin-right: .3em;"></span>
		<span id="cerne"></span></p>
	</div>
    <br/>
    <br/>
    <table id="tabela">
    	<thead>
    		<tr>
    			<th></th>
    			<th>Nome</th>
    			<th></th>
    			<th>Autor</th>
    			<th></th>
    			<th>Genero</th>
    			<th>Status</th>
    			
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
	
    <div id="modal" title="Novo livro"> 
		<!--<p class="validateTips">Campo obrigat�rio</p>-->
  		<form>
  			<fieldset>
   				<label for="nome">Nome</label>
    			<input type="text" name="nome" id="nome" class="text ui-widget-content ui-corner-all" />
				<label for="autor">Autor</label>
				<input name="autor" id="autor" type="text" />
				<label for="genero">Genero</label>
				<select name="genero" id="genero" >
					<c:forEach var="genero" items="${generos}">
						<option value="${genero.id}">${genero.nome}</option>
					</c:forEach>
				</select>
				<input type="hidden" name="id" id="id" />
  			</fieldset>
  		</form>
	</div>
</t:main>