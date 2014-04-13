
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
    	
    	$("#link_emprestimos").css("color","white");
    	
    	var incluir = function(id, exemplar, aluno, retirada, devolucao){
    		$.ajax({
    			url: "./emprestimo/incluir",
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				data: {"aluno": aluno.id, "exemplar": exemplar.id, "retirada": retirada, "devolucao": devolucao},
				success: function(result){
					incluiuComSucesso(result.id, result.exemplar, result.aluno, result.retirada, result.devolucao);
				},
				error: function(xhRequest, ErrorText, thrownError){
					msgErro(xhRequest.responseText);
				}
			});
    	};
    	
    	var incluiuComSucesso = function(id, exemplar, aluno, retirada, devolucao){
    		jModal.dialog( "close" );
    		jTabela.dataTable().fnAddData([id, exemplar.id, exemplar.resumo, aluno.id, aluno.resumo, retirada, devolucao]);			
    		msg("Emprestimo incluído com sucesso");
    	};
    	
		var alterar = function(id, exemplar, aluno, retirada, devolucao){
			$.getJSON("./emprestimo/alterar",{"id": id, "aluno": aluno.id, "exemplar": exemplar.id, "retirada": retirada, "devolucao": devolucao}, function(result){
				alterouComSucesso(result.id, result.exemplar, result.aluno, result.retirada, result.devolucao);
			}).fail(function(xhRequest, ErrorText, thrownError){
				msgErro(xhRequest.responseText);
			});
    	};
    	
    	var alterouComSucesso = function(id, exemplar, aluno, retirada, devolucao){
    		jModal.dialog( "close" );
    		jTabela.dataTable().fnUpdate([id, exemplar.id, exemplar.resumo, aluno.id, aluno.resumo, retirada, devolucao], $("#"+id)[0]);			
    		msg("Emprestimo alterado com sucesso");
    	}
    	
		var excluir = function(id){
    		$.getJSON("./emprestimo/excluir",{"id":id}, function(result){
    			excluiuComSucesso([result.id]);
    		}).fail(function(xhRequest, ErrorText, thrownError){
				msgErro(xhRequest.responseText);
			});
    	};
    	
    	var excluiuComSucesso = function(id){
    		jTabela.dataTable().fnDeleteRow($("#"+id)[0]);
    		msg("Emprestimo excluído com sucesso");
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
					$("#id").val(jModal.data('id'));
					exemplar_id = jModal.data('exemplar');
					$("#exemplar").val(exemplar_invertMapping[exemplar_id]);
					aluno_id = jModal.data('aluno');
					$("#aluno").val(aluno_invertMapping[aluno_id]);
					$("#retirada").datepicker("setDate", new Date());
					if (jModal.data('retirada'))
						$("#retirada").val(jModal.data('retirada'));
					$("#devolucao").val(jModal.data('devolucao'));
			},
			close: function() {
        		var allFields = $( [] ).add($("#nome"));
				allFields.val("").removeClass( "ui-state-error" );
				jModal.data('id', '');
				jModal.data('exemplar', '');
				jModal.data('aluno', '');
				jModal.data('retirada', '');
				jModal.data('devolucao', '');
      		},
      		buttons: {
       			"Ok": function() {
					var acao = jModal.data('acao'),
						id = $("#id"),
						exemplar = $("#exemplar"),
						aluno = $("#aluno"),
						retirada = $("#retirada"),
						devolucao = $("#devolucao");
					acao(id.val(), {"id": exemplar_id, "resumo": exemplar.val()}, {"id": aluno_id, "resumo": aluno.val()}, retirada.val(), devolucao.val());
          		},
        		"Cancelar": function() {
          			jModal.dialog( "close" );
          		}
      		}
    	});
        
        $("#devolucao").datepicker();
        $("#devolucao").datepicker( "option", "dateFormat", "dd/mm/yy" );
        
    	$("#retirada").datepicker();
    	$("#retirada").datepicker( "option", "dateFormat", "dd/mm/yy" );
        
    	var exemplar_id = null;
    	var exemplar_raw = [
			//<c:forEach var="exemplar" items="${exemplares}">
			{id: "${exemplar.id}", value: "${exemplar.resumo}", label: "${exemplar.resumo}"},
			//</c:forEach>
		];
    	var exemplar_source  = [ ];
    	var exemplar_mapping = { };
    	var exemplar_invertMapping = {};
    	for(var i = 0; i < exemplar_raw.length; ++i) {
    	    exemplar_source.push({"label":exemplar_raw[i].label, "value":exemplar_raw[i].value});
    	    exemplar_mapping[exemplar_raw[i].value] = exemplar_raw[i].id;
    	    exemplar_invertMapping[exemplar_raw[i].id] = exemplar_raw[i].value;
    	}
    	$( "#exemplar").autocomplete({
            source: exemplar_source,
            select: function(event, ui) {
            	exemplar_id = exemplar_mapping[ui.item.value];
            },
        });
    	$("#exemplar").blur(function(){
    		if (exemplar_mapping[$("#exemplar").val()] == 'undefined' || exemplar_mapping[$("#exemplar").val()] == null){
        		$("#exemplar").val("");
        		exemplar_id = null;
    		}
    	});
    	
    	
    	var aluno_id = null;
    	var aluno_raw = [
			//<c:forEach var="aluno" items="${alunos}">
			{id: "${aluno.id}", value: "${aluno.resumo}", label: "${aluno.resumo}"},
			//</c:forEach>
		];
    	var aluno_source  = [ ];
    	var aluno_mapping = { };
    	var aluno_invertMapping = {};
    	for(var i = 0; i < aluno_raw.length; ++i) {
    		aluno_source.push({"label":aluno_raw[i].label, "value":aluno_raw[i].value});
    		aluno_mapping[aluno_raw[i].value] = aluno_raw[i].id;
    		aluno_invertMapping[aluno_raw[i].id] = aluno_raw[i].value;
    	}
    	$( "#aluno").autocomplete({
            source: aluno_source,
            select: function(event, ui) {
            	aluno_id = aluno_mapping[ui.item.value];
            },
        });
    	$("#aluno").blur(function(){
    		if (aluno_mapping[$("#aluno").val()] == 'undefined' || aluno_mapping[$("#aluno").val()] == null){
        		$("#aluno").val("");
        		aluno_id = null;
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
				var exemplar = this.fnGetData(nRow)[1];
				var aluno = this.fnGetData(nRow)[3];
				var retirada = this.fnGetData(nRow)[5];
				var devolucao = this.fnGetData(nRow)[6];
				var jnRow = $(nRow);
				var divIcones = jnRow.find("[name = 'icones']");
         		divIcones.append("&nbsp;&nbsp;<span title=\"Editar\" style=\"display: inline-block; visibility:hidden; cursor: pointer\" class=\"ui-state-default ui-corner-all ui-icon ui-icon-pencil\"></span>");
         		divIcones.append("&nbsp;&nbsp;<span title=\"Excluir\" style=\"display: inline-block; visibility:hidden; cursor: pointer\" class=\"ui-state-default ui-corner-all ui-icon ui-icon-close\"></a>");
				divIcones.find("span:eq(0)").click(function(){
					jModal.data('acao', alterar)
		    		.data('id', id)
		    		.data('exemplar', exemplar)
		    		.data('aluno', aluno)
		    		.data('retirada', retirada)
		    		.data('devolucao', devolucao)
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
			<c:forEach var="emprestimo" items="${emprestimos}">
				{
					"0": "${emprestimo.id}",
					"1": "${emprestimo.exemplar.id}",
					"2": "${emprestimo.exemplar.resumo}",
					"3": "${emprestimo.aluno.id}",
					"4": "${emprestimo.aluno.resumo}",
					"5": "${emprestimo.retiradaDDMMYYYY}",
					"6": "${emprestimo.devolucaoDDMMYYYY}"
				},
			</c:forEach>
			],
			"aoColumnDefs": [
				{ 
					"bVisible": false, 
					"aTargets": [ 0 ] 
				},
				{ 
					"bVisible": false, 
					"aTargets": [ 1 ] 
				},
				{
					"mRender": function ( data, type, row ) {
						return data + "<div name='icones' style='display: inline-block'></div>";
					},
					"aTargets": [ 2 ]
				},
				{ 
					"bVisible": false, 
					"aTargets": [ 3 ] 
				},
				{ 
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
	
    <button id="incluir">Novo emprestimo</button>
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
    			<th></th>
    			<th>Livro</th>
    			<th></th>
    			<th>Aluno</th>
    			<th>Retirada</th>
    			<th>Devolução</th>
    			
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
	
    <div id="modal" title="Novo emprestimo"> 
		<!--<p class="validateTips">Campo obrigat�rio</p>-->
  		<form>
  			<fieldset>
				<label for="exemplar">Livro</label>
				<input name="exemplar" id="exemplar" type="text" class="text ui-widget-content ui-corner-all" />
				<label for="aluno">Aluno</label>
				<input name="aluno" id="aluno" type="text" class="text ui-widget-content ui-corner-all" />
				<label for="retirada">Retirada</label>
    			<input type="text" name="retirada" id="retirada" class="text ui-widget-content ui-corner-all" />
    			<label for="devolucao">Devolução</label>
    			<input type="text" name="devolucao" id="devolucao" class="text ui-widget-content ui-corner-all" />
				<input type="hidden" name="id" id="id" />
  			</fieldset>
  		</form>
	</div>
</t:main>