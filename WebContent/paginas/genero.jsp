
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
    	
    	$("#link_generos").css("color","white");
    	
    	var incluir = function(nome){
    		$.ajax({
    			url: "./genero/incluir",
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				data: {'nome': nome },
				success: function(result){
					incluiuComSucesso(result.nome, result.id);
				}
			});
    	};
    	
    	var incluiuComSucesso = function(nome, id){
    		jModal.dialog( "close" );
    		jTabela.dataTable().fnAddData([nome, id]);			
    		msg("Gênero incluído com sucesso");
    	}
    	
		var alterar = function(nome, id){
			$.getJSON("./genero/alterar",{"nome":nome, "id":id}, function(result){
				alterouComSucesso(result.nome, result.id);
			});
    	};
    	
    	var alterouComSucesso = function(nome, id){
    		jModal.dialog( "close" );
    		jTabela.dataTable().fnUpdate([nome, id], $("#"+id)[0]);			
    		msg("Gênero alterado com sucesso");
    	}
    	
		var excluir = function(id){
    		$.getJSON("./genero/excluir",{"id":id}, function(result){
    			excluiuComSucesso([result.id]);
    		});
    	};
    	
    	var excluiuComSucesso = function(id){
    		jTabela.dataTable().fnDeleteRow($("#"+id)[0]);
    		msg("Gênero exclu�do com sucesso");
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
			},
			close: function() {
        		var allFields = $( [] ).add($("#nome"));
				allFields.val("").removeClass( "ui-state-error" );
				jModal.data('nome', '');
				jModal.data('id', '');
      		},
      		buttons: {
       			"Ok": function() {
					var acao = jModal.data('acao'),
						nome = $("#nome"), id = $("#id");
					if (nome.val().length == 0){	
						nome.addClass( "ui-state-error" );
						//$( ".validateTips" ).addClass( "ui-state-highlight" );
						return;
					}
					acao(nome.val(), id.val());
          		},
        		"Cancelar": function() {
          			jModal.dialog( "close" );
          		}
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
				var nome = this.fnGetData(nRow)[0];
				var id = this.fnGetData(nRow)[1];
				var jnRow = $(nRow);
				var divIcones = jnRow.find("[name = 'icones']");
         		divIcones.append("&nbsp;&nbsp;<span title=\"Editar\" style=\"display: inline-block; visibility:hidden; cursor: pointer\" class=\"ui-state-default ui-corner-all ui-icon ui-icon-pencil\"></span>");
         		divIcones.append("&nbsp;&nbsp;<span title=\"Excluir\" style=\"display: inline-block; visibility:hidden; cursor: pointer\" class=\"ui-state-default ui-corner-all ui-icon ui-icon-close\"></a>");
				divIcones.find("span:eq(0)").click(function(){
					jModal.data('acao', alterar)
		    		.data('nome', nome)
		    		.data('id', id)
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
			<c:forEach var="genero" items="${generos}">
				{
					"0": "${genero.nome}",
					"1": "${genero.id}"
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
	
    <button id="incluir">Novo gênero</button>
	<div id="mensagem" class="ui-state-highlight ui-corner-all" style=" margin-top: 0px; padding: 0 .7em; display: inline-block; position: absolute; left: 200px; top: 10px; ">
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
	
    <div id="modal" title="Novo Gênero"> 
		<!--<p class="validateTips">Campo obrigat�rio</p>-->
  		<form>
  			<fieldset>
   				<label for="nome">Nome</label>
    			<input type="text" name="nome" id="nome" class="text ui-widget-content ui-corner-all" />
				<input type="hidden" name="id" id="id" />
  			</fieldset>
  		</form>
	</div>
</t:main>