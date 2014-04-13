
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
    	
    	$("#link_alunos").css("color","white");
    	
    	var incluir = function(id, nome, matricula, turma){
    		$.ajax({
    			url: "./aluno/incluir",
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				data: {'nome': nome, 'matricula':matricula, "turma": turma.id},
				success: function(result){
					incluiuComSucesso(result.id, result.nome, result.matricula, result.turma);
				},
				error: function(xhRequest, ErrorText, thrownError){
					msgErro(xhRequest.responseText);
				}
			});
    	};
    	
    	var incluiuComSucesso = function(id, nome, matricula, turma){
    		jModal.dialog( "close" );
    		jTabela.dataTable().fnAddData([id, nome, matricula, turma.id, turma.nome]);			
    		msg("Aluno incluído com sucesso");
    	}
    	
		var alterar = function(id, nome, matricula, turma){
			$.getJSON("./aluno/alterar",{"nome":nome, "id":id, "matricula":matricula, "turma":turma.id}, function(result){
				alterouComSucesso(result.id, result.nome, result.matricula, result.turma);
			}).fail(function(xhRequest, ErrorText, thrownError){
				msgErro(xhRequest.responseText);
			});
    	};
    	
    	var alterouComSucesso = function(id, nome, matricula, turma){
    		jModal.dialog( "close" );
    		jTabela.dataTable().fnUpdate([id, nome, matricula, turma.id, turma.nome], $("#"+id)[0]);			
    		msg("Aluno alterado com sucesso");
    	}
    	
		var excluir = function(id){
    		$.getJSON("./aluno/excluir",{"id":id}, function(result){
    			excluiuComSucesso([result.id]);
    		}).fail(function(xhRequest, ErrorText, thrownError){
				msgErro(xhRequest.responseText);
			});
    	};
    	
    	var excluiuComSucesso = function(id){
    		jTabela.dataTable().fnDeleteRow($("#"+id)[0]);
    		msg("Aluno excluído com sucesso");
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
					$("#matricula").val(jModal.data('matricula'));
					$("#id").val(jModal.data('id'));
					$("#turma").val(jModal.data('turma'));
			},
			close: function() {
        		var allFields = $( [] ).add($("#nome"));
				allFields.val("").removeClass( "ui-state-error" );
				jModal.data('nome', '');
				jModal.data('id', '');
				jModal.data('matricula', '');
				jModal.data('turma', '');
      		},
      		buttons: {
       			"Ok": function() {
					var acao = jModal.data('acao'),
						nome = $("#nome"), 
						id = $("#id"),
						matricula = $("#matricula"),
						turma = $("#turma option:selected");
					if (nome.val().length == 0){	
						nome.addClass( "ui-state-error" );
						//$( ".validateTips" ).addClass( "ui-state-highlight" );
						return;
					}
					acao(id.val(), nome.val(), matricula.val(), {"id": turma.val(), "nome": turma.text()});
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
				var id = this.fnGetData(nRow)[0];
				var nome = this.fnGetData(nRow)[1];
				var matricula = this.fnGetData(nRow)[2];
				var turma = this.fnGetData(nRow)[3];
				var jnRow = $(nRow);
				var divIcones = jnRow.find("[name = 'icones']");
         		divIcones.append("&nbsp;&nbsp;<span title=\"Editar\" style=\"display: inline-block; visibility:hidden; cursor: pointer\" class=\"ui-state-default ui-corner-all ui-icon ui-icon-pencil\"></span>");
         		divIcones.append("&nbsp;&nbsp;<span title=\"Excluir\" style=\"display: inline-block; visibility:hidden; cursor: pointer\" class=\"ui-state-default ui-corner-all ui-icon ui-icon-close\"></a>");
				divIcones.find("span:eq(0)").click(function(){
					jModal.data('acao', alterar)
		    		.data('nome', nome)
		    		.data('id', id)
		    		.data('matricula', matricula)
		    		.data('turma', turma)
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
			<c:forEach var="aluno" items="${alunos}">
				{
					"0": "${aluno.id}",
					"1": "${aluno.nome}",
					"2": "${aluno.matricula}",
					"3": "${aluno.turma.id}",
					"4": "${aluno.turma.nome}"
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
					"aTargets": [ 2 ] 
				},
				{ 
					"bVisible": false, 
					"aTargets": [ 3 ] 
				},
				{  
					"aTargets": [ 4 ] 
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
	
    <button id="incluir">Novo aluno</button>
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
    			<th>Matrícula</th>
    			<th></th>
    			<th>Turma</th>
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
	
    <div id="modal" title="Novo Aluno"> 
		<!--<p class="validateTips">Campo obrigat�rio</p>-->
  		<form>
  			<fieldset>
   				<label for="nome">Nome</label>
    			<input type="text" name="nome" id="nome" class="text ui-widget-content ui-corner-all" />
    			<label for="matricula">Matrícula</label>
    			<input type="text" name="matricula" id="matricula" class="text ui-widget-content ui-corner-all" />
				<label for="turma">Turma</label>
				<select name="turma" id="turma" class="text ui-widget-content ui-corner-all">
					<c:forEach var="turma" items="${turmas}">
						<option value="${turma.id}">${turma.nome}</option>
					</c:forEach>
				</select>
				<input type="hidden" name="id" id="id" />
  			</fieldset>
  		</form>
	</div>
</t:main>