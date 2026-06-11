<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<article class="metric-card">
    <div class="metric-icon">
        <i class="${param.icon}"></i>
    </div>
    <p class="metric-label">${param.label}</p>
    <p class="metric-value ${param.valueClass}">${param.valueHtml}</p>
    <div class="metric-sub" id="${param.subId}">${param.sub}</div>
</article>
