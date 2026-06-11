<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<section class="content-panel">
    <div class="metric-grid">
        <jsp:include page="metric-card.jsp">
            <jsp:param name="icon" value="fa-solid fa-gauge-high" />
            <jsp:param name="label" value="Humedad del suelo" />
            <jsp:param name="valueClass" value="" />
            <jsp:param name="valueHtml" value='<span id="humidityValue">--</span><span id="humidityUnit">%</span>' />
            <jsp:param name="sub" value="Esperando lecturas" />
            <jsp:param name="subId" value="humidityLabel" />
        </jsp:include>

        <jsp:include page="metric-card.jsp">
            <jsp:param name="icon" value="fa-solid fa-circle-check" />
            <jsp:param name="label" value="Nivel de agua" />
            <jsp:param name="valueClass" value="fs-4" />
            <jsp:param name="valueHtml" value='<span id="waterDistance">--</span> <span class="fs-6">cm</span>' />
            <jsp:param name="sub" value="Sin datos del sensor" />
            <jsp:param name="subId" value="waterLabel" />
        </jsp:include>

        <jsp:include page="metric-card.jsp">
            <jsp:param name="icon" value="fa-solid fa-pump-soap" />
            <jsp:param name="label" value="Bomba" />
            <jsp:param name="valueClass" value="fs-4" />
            <jsp:param name="valueHtml" value='<span id="pumpState" class="state-pill manual">Sin actividad</span>' />
            <jsp:param name="sub" value="Consultando eventos de riego" />
            <jsp:param name="subId" value="pumpLabel" />
        </jsp:include>

        <jsp:include page="metric-card.jsp">
            <jsp:param name="icon" value="fa-solid fa-robot" />
            <jsp:param name="label" value="Modo" />
            <jsp:param name="valueClass" value="fs-4" />
            <jsp:param name="valueHtml" value='<span id="irrigationMode" class="state-pill manual"><i class="fa-solid fa-hand"></i> --</span>' />
            <jsp:param name="sub" value="Sin configuraci&oacute;n" />
            <jsp:param name="subId" value="modeLabel" />
        </jsp:include>
    </div>

    <jsp:include page="chart-panel.jsp" />
</section>
