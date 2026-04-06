<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="메뉴 — 로운"/>
<%@ include file="../common/header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/menu-full.css">

<div class="menu-page">

    <div class="menu-header">
        <p>Our Menu</p>
        <h1>Menu</h1>
        <div class="divider"></div>
        <p class="note">프리미엄 + 중간 평균가 기준 &nbsp;|&nbsp; 2025</p>
    </div>

    <div class="category-tabs">
        <button class="tab-btn active" onclick="showTab('coffee', this)">커피</button>
        <button class="tab-btn" onclick="showTab('noncoffee', this)">논커피</button>
        <button class="tab-btn" onclick="showTab('ade', this)">에이드 &amp; 스무디</button>
        <button class="tab-btn" onclick="showTab('tea', this)">티</button>
        <button class="tab-btn" onclick="showTab('frappe', this)">블렌디드 / 프라페</button>
        <button class="tab-btn" onclick="showTab('dessert', this)">디저트 &amp; 푸드</button>
    </div>

    <!-- ===== 커피 ===== -->
    <div id="coffee" class="menu-section active">
        <h2 class="section-title">Coffee</h2>
        <p class="section-sub">커피</p>
        <div class="menu-grid">

            <div class="menu-card" onclick="openDetail(this)"
                 data-name="에스프레소" data-type="HOT" data-price="3,600원"
                 data-img="https://images.unsplash.com/photo-1510591509098-f4fdc6d0ff04?w=600&h=400&fit=crop&auto=format"
                 data-story="에스프레소는 이탈리아어로 '빠른'이라는 뜻을 지닌 커피의 정수입니다. 20세기 초 밀라노에서 탄생한 이 음료는 9기압의 고압으로 25~30초 만에 추출하여 커피의 진한 풍미와 황금빛 크레마를 완성합니다. 한 모금에 담긴 깊은 농도가 이탈리아인들의 하루를 깨워왔듯, 오늘 당신의 하루도 시작해 드립니다.">
                <img src="https://images.unsplash.com/photo-1510591509098-f4fdc6d0ff04?w=400&h=280&fit=crop&auto=format" alt="에스프레소" onerror="imgError(this)">
                <p class="item-name">에스프레소</p>
                <p class="item-type">HOT</p>
                <div class="price-row"><span class="price-label">avg</span><span class="price">3,600원</span></div>
            </div>

            <div class="menu-card" onclick="openDetail(this)"
                 data-name="아메리카노" data-type="HOT / ICE" data-price="4,200원"
                 data-img="https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&h=400&fit=crop&auto=format"
                 data-story="제2차 세계대전 당시 이탈리아에 주둔한 미군 병사들이 에스프레소의 강한 맛을 물로 희석해 마시기 시작한 것이 아메리카노의 유래입니다. 이탈리아 바리스타들이 '카페 아메리카노'라 부르며 놀린 것이 오늘날 세계에서 가장 사랑받는 커피가 되었습니다. 에스프레소의 깊은 향과 물의 부드러움이 어우러진 균형의 미학입니다.">
                <img src="https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=400&h=280&fit=crop&auto=format" alt="아메리카노" onerror="imgError(this)">
                <p class="item-name">아메리카노</p>
                <p class="item-type">HOT / ICE</p>
                <div class="price-row"><span class="price-label">avg</span><span class="price">4,200원</span></div>
            </div>

            <div class="menu-card" onclick="openDetail(this)"
                 data-name="카페라떼" data-type="HOT / ICE" data-price="4,700원"
                 data-img="https://images.unsplash.com/photo-1570968915860-54d5c301fa9f?w=600&h=400&fit=crop&auto=format"
                 data-story="라떼는 이탈리아어로 '우유'를 의미합니다. 이탈리아 가정에서 아침 식사와 함께 마시던 문화에서 시작된 카페라떼는 에스프레소 위에 스팀 밀크를 부어 부드럽고 크리미한 풍미를 완성합니다. 바리스타의 손끝에서 탄생하는 라떼아트는 한 잔의 커피를 작은 예술로 만들어 드립니다.">
                <img src="https://images.unsplash.com/photo-1541167760496-1628856ab772?w=400&h=280&fit=crop&auto=format" alt="카페라떼" onerror="imgError(this)">
                <p class="item-name">카페라떼</p>
                <p class="item-type">HOT / ICE</p>
                <div class="price-row"><span class="price-label">avg</span><span class="price">4,700원</span></div>
            </div>

            <div class="menu-card" onclick="openDetail(this)"
                 data-name="카푸치노" data-type="HOT / ICE" data-price="4,700원"
                 data-img="https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=600&h=400&fit=crop&auto=format"
                 data-story="카푸치노는 이탈리아 카푸친 수도회 수도사들의 갈색 수도복에서 이름이 유래했습니다. 에스프레소·스팀 밀크·우유 거품을 1:1:1 비율로 담아내는 것이 정통 방식이며, 풍성한 거품이 만들어내는 벨벳 같은 식감이 특징입니다. 오전 11시 이전에 마시는 것이 이탈리아의 전통입니다.">
                <img src="https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=400&h=280&fit=crop&auto=format" alt="카푸치노" onerror="imgError(this)">
                <p class="item-name">카푸치노</p>
                <p class="item-type">HOT / ICE</p>
                <div class="price-row"><span class="price-label">avg</span><span class="price">4,700원</span></div>
            </div>

            <div class="menu-card" onclick="openDetail(this)"
                 data-name="바닐라라떼" data-type="HOT / ICE" data-price="5,300원"
                 data-img="https://images.unsplash.com/photo-1561047029-3000c68339ca?w=600&h=400&fit=crop&auto=format"
                 data-story="바닐라는 멕시코 원주민 토토낙족이 처음 발견한 향신료로, 16세기 스페인 탐험가들에 의해 유럽에 전해졌습니다. 마다가스카르의 뜨거운 태양 아래 재배된 바닐라빈의 달콤하고 따뜻한 향이 에스프레소의 쌉쌀함과 만나 완벽한 균형을 이룹니다. 하루 중 가장 달콤한 순간을 선물해 드립니다.">
                <img src="https://images.unsplash.com/photo-1561047029-3000c68339ca?w=400&h=280&fit=crop&auto=format" alt="바닐라라떼" onerror="imgError(this)">
                <p class="item-name">바닐라라떼</p>
                <p class="item-type">HOT / ICE</p>
                <div class="price-row"><span class="price-label">avg</span><span class="price">5,300원</span></div>
            </div>

            <div class="menu-card" onclick="openDetail(this)"
                 data-name="카라멜마키아토" data-type="HOT / ICE" data-price="5,650원"
                 data-img="https://images.unsplash.com/photo-1590138695581-1e82b57e78d1?w=600&h=400&fit=crop&auto=format"
                 data-story="마키아토는 이탈리아어로 '점을 찍다'라는 뜻입니다. 바닐라 시럽과 스팀 밀크 위에 에스프레소를 천천히 부어 아름다운 레이어를 만들고, 황금빛 카라멜 소스로 마무리합니다. 마실수록 층층이 변하는 맛의 여정이 카라멜마키아토만의 특별한 이야기를 만들어냅니다.">
                <img src="https://images.unsplash.com/photo-1590138695581-1e82b57e78d1?w=400&h=280&fit=crop&auto=format" alt="카라멜마키아토" onerror="imgError(this)">
                <p class="item-name">카라멜마키아토</p>
                <p class="item-type">HOT / ICE</p>
                <div class="price-row"><span class="price-label">avg</span><span class="price">5,650원</span></div>
            </div>

            <div class="menu-card" onclick="openDetail(this)"
                 data-name="카페모카" data-type="HOT / ICE" data-price="5,300원"
                 data-img="https://images.unsplash.com/photo-1534778101976-62847782c213?w=600&h=400&fit=crop&auto=format"
                 data-story="카페모카의 이름은 15세기 커피 무역의 중심지였던 예멘의 항구도시 '모카(Mocha)'에서 유래했습니다. 그 시절 모카에서 재배된 커피는 천연 초콜릿 향으로 유명했고, 훗날 커피와 초콜릿을 직접 결합한 음료로 재탄생했습니다. 달콤 쌉쌀한 초콜릿과 진한 에스프레소의 만남, 하루의 피로를 달래줍니다.">
                <img src="https://images.unsplash.com/photo-1534778101976-62847782c213?w=400&h=280&fit=crop&auto=format" alt="카페모카" onerror="imgError(this)">
                <p class="item-name">카페모카</p>
                <p class="item-type">HOT / ICE</p>
                <div class="price-row"><span class="price-label">avg</span><span class="price">5,300원</span></div>
            </div>

            <div class="menu-card" onclick="openDetail(this)"
                 data-name="헤이즐넛라떼" data-type="HOT / ICE" data-price="5,300원"
                 data-img="https://images.unsplash.com/photo-1574914629377-e97c19438717?w=600&h=400&fit=crop&auto=format"
                 data-story="이탈리아 피에몬테 지방은 세계 최고의 헤이즐넛 산지로 유명합니다. 이 지역에서 탄생한 헤이즐넛 향은 에스프레소와 만나 고소하면서도 달콤한 풍미의 라떼를 완성했습니다. 구운 견과류의 따뜻한 향이 가득한 한 잔은 가을 낙엽처럼 마음을 포근하게 감싸줍니다.">
                <img src="https://images.unsplash.com/photo-1574914629377-e97c19438717?w=400&h=280&fit=crop&auto=format" alt="헤이즐넛라떼" onerror="imgError(this)">
                <p class="item-name">헤이즐넛라떼</p>
                <p class="item-type">HOT / ICE</p>
                <div class="price-row"><span class="price-label">avg</span><span class="price">5,300원</span></div>
            </div>

            <div class="menu-card" onclick="openDetail(this)"
                 data-name="돌체라떼" data-type="HOT / ICE" data-price="5,400원"
                 data-img="https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=600&h=400&fit=crop&auto=format"
                 data-story="돌체(Dolce)는 이탈리아어로 '달콤한'이라는 뜻입니다. 연유를 베이스로 한 부드럽고 달콤한 크림이 에스프레소와 만나 탄생한 돌체라떼는 이탈리아 남부 디저트 문화에서 영감을 받았습니다. 진한 에스프레소 위에 살포시 올라간 달콤한 크림 한 층이 일상에 작은 사치를 선사합니다.">
                <img src="https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=400&h=280&fit=crop&auto=format" alt="돌체라떼" onerror="imgError(this)">
                <p class="item-name">돌체라떼</p>
                <p class="item-type">HOT / ICE</p>
                <div class="price-row"><span class="price-label">avg</span><span class="price">5,400원</span></div>
            </div>

            <div class="menu-card" onclick="openDetail(this)"
                 data-name="아포가토" data-type="ICE" data-price="5,600원"
                 data-img="https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=600&h=400&fit=crop&auto=format"
                 data-story="아포가토(Affogato)는 이탈리아어로 '물에 빠진'이라는 뜻입니다. 뜨거운 에스프레소 한 샷을 바닐라 아이스크림 위에 부으면 뜨거움과 차가움, 쓴맛과 단맛이 어우러지며 천천히 녹아드는 마법이 시작됩니다. 이탈리아에서는 식후 디저트로 즐기는 특별한 한 잔입니다.">
                <img src="https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=400&h=280&fit=crop&auto=format" alt="아포가토" onerror="imgError(this)">
                <p class="item-name">아포가토</p>
                <p class="item-type">ICE</p>
                <div class="price-row"><span class="price-label">avg</span><span class="price">5,600원</span></div>
            </div>

            <div class="menu-card" onclick="openDetail(this)"
                 data-name="콜드브루" data-type="ICE" data-price="4,450원"
                 data-img="https://images.unsplash.com/photo-1556791766-66ac915737cf?w=600&h=400&fit=crop&auto=format"
                 data-story="콜드브루는 일본 교토의 전통 냉침 추출 방식에서 유래했습니다. 뜨거운 물 대신 차가운 물로 12~24시간 천천히 추출하여 산도는 낮추고 자연스러운 단맛과 깊은 풍미를 최대한 끌어냅니다. 시간이 만들어내는 커피, 서두르지 않는 느림의 미학을 담은 한 잔입니다.">
                <img src="https://images.unsplash.com/photo-1556791766-66ac915737cf?w=400&h=280&fit=crop&auto=format" alt="콜드브루" onerror="imgError(this)">
                <p class="item-name">콜드브루</p>
                <p class="item-type">ICE</p>
                <div class="price-row"><span class="price-label">avg</span><span class="price">4,450원</span></div>
            </div>

            <div class="menu-card" onclick="openDetail(this)"
                 data-name="콜드브루라떼" data-type="ICE" data-price="5,150원"
                 data-img="https://images.unsplash.com/photo-1545285179-78da7c2b8f83?w=600&h=400&fit=crop&auto=format"
                 data-story="12시간 냉침 추출한 콜드브루에 신선한 우유를 더해 완성됩니다. 콜드브루 특유의 낮은 산도와 깊은 단맛이 고소한 우유와 만나 부드럽고 진한 풍미를 만들어냅니다. 더운 여름날 한 모금에 온몸이 시원해지는 여름의 단골 메뉴입니다.">
                <img src="https://images.unsplash.com/photo-1545285179-78da7c2b8f83?w=400&h=280&fit=crop&auto=format" alt="콜드브루라떼" onerror="imgError(this)">
                <p class="item-name">콜드브루라떼</p>
                <p class="item-type">ICE</p>
                <div class="price-row"><span class="price-label">avg</span><span class="price">5,150원</span></div>
            </div>

            <div class="menu-card" onclick="openDetail(this)"
                 data-name="드립커피" data-type="HOT / ICE" data-price="4,000원"
                 data-img="https://images.unsplash.com/photo-1439242088854-0c76045f4124?w=600&h=400&fit=crop&auto=format"
                 data-story="핸드드립은 바리스타의 손으로 직접 물을 부어 커피를 추출하는 방식입니다. 물의 온도, 붓는 속도, 원두의 분쇄도가 한 잔의 맛을 결정하는 정성의 과정입니다. 기계가 아닌 사람의 온도가 담긴 드립커피는 바리스타와 손님 사이에 존재하는 조용한 대화입니다.">
                <img src="https://images.unsplash.com/photo-1439242088854-0c76045f4124?w=400&h=280&fit=crop&auto=format" alt="드립커피" onerror="imgError(this)">
                <p class="item-name">드립커피</p>
                <p class="item-type">HOT / ICE</p>
                <div class="price-row"><span class="price-label">avg</span><span class="price">4,000원</span></div>
            </div>

        </div>
    </div>

    <!-- ===== 논커피 ===== -->
    <div id="noncoffee" class="menu-section">
        <h2 class="section-title">Non-Coffee</h2>
        <p class="section-sub">논커피</p>
        <div class="menu-grid">

            <div class="menu-card" onclick="openDetail(this)"
                 data-name="녹차라떼" data-type="HOT / ICE" data-price="5,400원"
                 data-img="https://images.unsplash.com/photo-1536256263959-770b48d82b0a?w=600&h=400&fit=crop&auto=format"
                 data-story="일본 우지(宇治) 지방의 말차는 차 문화의 정점으로 불립니다. 고온을 피해 재배된 찻잎을 맷돌로 곱게 갈아 만든 말차는 선명한 녹색과 깊은 감칠맛이 특징입니다. 이 고귀한 말차가 부드러운 스팀 밀크와 만나 일본 다도의 고요함을 한 잔에 담아냅니다.">
                <img src="https://images.unsplash.com/photo-1536256263959-770b48d82b0a?w=400&h=280&fit=crop&auto=format" alt="녹차라떼" onerror="imgError(this)">
                <p class="item-name">녹차라떼</p>
                <p class="item-type">HOT / ICE</p>
                <div class="price-row"><span class="price-label">avg</span><span class="price">5,400원</span></div>
            </div>

            <div class="menu-card" onclick="openDetail(this)"
                 data-name="고구마라떼" data-type="HOT / ICE" data-price="5,100원"
                 data-img=""
                 data-story="한국의 가을, 노릇하게 구운 고구마 향은 어릴 적 추억을 소환합니다. 달콤하고 구수한 국내산 고구마를 직접 쪄서 만든 고구마 페이스트를 따뜻한 우유와 블렌딩하여 완성합니다. 한 모금 마시면 포근한 한국의 가을이 온몸을 감싸는 듯한 느낌입니다.">
                <div class="img-placeholder">📷 사진 준비 중</div>
                <p class="item-name">고구마라떼</p>
                <p class="item-type">HOT / ICE</p>
                <div class="price-row"><span class="price-label">avg</span><span class="price">5,100원</span></div>
            </div>

            <div class="menu-card" onclick="openDetail(this)"
                 data-name="초콜릿 (핫초코)" data-type="HOT / ICE" data-price="5,100원"
                 data-img="https://images.unsplash.com/photo-1542990253-0d0f5be5f0ed?w=600&h=400&fit=crop&auto=format"
                 data-story="초콜릿의 역사는 3,000년 전 고대 아즈텍 문명으로 거슬러 올라갑니다. 신의 음식이라 불리던 카카오는 16세기 스페인을 통해 유럽으로 전해졌고, 설탕과 우유를 더해 오늘날의 핫초코가 탄생했습니다. 벨기에산 다크 초콜릿의 깊은 풍미가 포근한 우유 안에 녹아드는 이 한 잔은 위로의 음료입니다.">
                <img src="https://images.unsplash.com/photo-1542990253-0d0f5be5f0ed?w=400&h=280&fit=crop&auto=format" alt="초콜릿" onerror="imgError(this)">
                <p class="item-name">초콜릿 (핫초코)</p>
                <p class="item-type">HOT / ICE</p>
                <div class="price-row"><span class="price-label">avg</span><span class="price">5,100원</span></div>
            </div>

            <div class="menu-card" onclick="openDetail(this)"
                 data-name="딸기라떼" data-type="HOT / ICE" data-price="5,600원"
                 data-img=""
                 data-story="봄의 전령사, 담양과 논산의 붉고 탐스러운 딸기가 우유 속에 녹아듭니다. 인공 향료 없이 신선한 딸기 과육과 퓨레를 직접 블렌딩하여 새콤달콤한 자연의 맛을 그대로 담았습니다. 분홍빛 빛깔만큼이나 기분까지 화사해지는 딸기라떼입니다.">
                <div class="img-placeholder">📷 사진 준비 중</div>
                <p class="item-name">딸기라떼</p>
                <p class="item-type">HOT / ICE</p>
                <div class="price-row"><span class="price-label">avg</span><span class="price">5,600원</span></div>
            </div>

            <div class="menu-card" onclick="openDetail(this)"
                 data-name="토피넛라떼" data-type="HOT / ICE" data-price="5,300원"
                 data-img="https://images.unsplash.com/photo-1530124175301-15984e162c84?w=600&h=400&fit=crop&auto=format"
                 data-story="토피(Toffee)는 영국 빅토리아 시대부터 사랑받아온 전통 캔디입니다. 버터와 설탕을 천천히 캐러멜라이징한 토피의 풍미에 구운 헤이즐넛의 고소함을 더해 탄생한 토피넛 시럽이 부드러운 우유와 어우러집니다. 달콤하고 따뜻한 영국 겨울 오후의 정취를 담은 음료입니다.">
                <img src="https://images.unsplash.com/photo-1530124175301-15984e162c84?w=400&h=280&fit=crop&auto=format" alt="토피넛라떼" onerror="imgError(this)">
                <p class="item-name">토피넛라떼</p>
                <p class="item-type">HOT / ICE</p>
                <div class="price-row"><span class="price-label">avg</span><span class="price">5,300원</span></div>
            </div>

            <div class="menu-card" onclick="openDetail(this)"
                 data-name="밀크티" data-type="HOT / ICE" data-price="5,000원"
                 data-img=""
                 data-story="영국 빅토리아 여왕의 오후 5시, 웨일즈 공작 부인 애나 마리아가 처음 시작했다는 애프터눈 티 문화에서 밀크티는 탄생했습니다. 오늘날 대만의 버블티부터 인도의 차이까지, 각국의 문화가 담긴 밀크티는 세계에서 가장 다양하게 변주되는 음료입니다. 진하게 우린 홍차와 신선한 우유의 클래식한 조화를 즐겨보세요.">
                <div class="img-placeholder">📷 사진 준비 중</div>
                <p class="item-name">밀크티</p>
                <p class="item-type">HOT / ICE</p>
                <div class="price-row"><span class="price-label">avg</span><span class="price">5,000원</span></div>
            </div>

        </div>
    </div>

    <!-- ===== 에이드 & 스무디 ===== -->
    <div id="ade" class="menu-section">
        <h2 class="section-title">Ade &amp; Smoothie</h2>
        <p class="section-sub">에이드 &amp; 스무디</p>

        <div class="sub-category">
            <p class="sub-title">에이드</p>
            <div class="menu-grid">
                <div class="menu-card" onclick="openDetail(this)"
                     data-name="레몬에이드" data-type="ICE" data-price="5,200원"
                     data-img="https://images.unsplash.com/photo-1621263764928-df1444c5e859?w=600&h=400&fit=crop&auto=format"
                     data-story="지중해 시칠리아의 태양을 담은 레몬은 고대 아랍인들이 처음 재배하기 시작했습니다. 중세 이집트의 거리에서 레몬 시럽에 물을 탄 음료 '카타르지무스'가 에이드의 시초라 전해집니다. 제주산 청정 레몬의 상큼한 산미와 달콤함이 탄산과 만나 여름을 가장 맛있게 즐기는 방법을 알려드립니다.">
                    <img src="https://images.unsplash.com/photo-1621263764928-df1444c5e859?w=400&h=280&fit=crop&auto=format" alt="레몬에이드" onerror="imgError(this)">
                    <p class="item-name">레몬에이드</p>
                    <p class="item-type">ICE</p>
                    <div class="price-row"><span class="price-label">avg</span><span class="price">5,200원</span></div>
                </div>
                <div class="menu-card" onclick="openDetail(this)"
                     data-name="자몽에이드" data-type="ICE" data-price="5,200원"
                     data-img=""
                     data-story="자몽은 18세기 카리브해 바베이도스에서 오렌지와 포멜로의 자연 교배로 탄생한 과일입니다. '금단의 과일'이라는 별명처럼 첫맛은 쌉쌀하지만 뒤따라오는 상큼한 단맛이 중독성 있습니다. 신선한 자몽 착즙에 탄산을 더해 더운 날의 갈증을 시원하게 해결해 드립니다.">
                    <div class="img-placeholder">📷 사진 준비 중</div>
                    <p class="item-name">자몽에이드</p>
                    <p class="item-type">ICE</p>
                    <div class="price-row"><span class="price-label">avg</span><span class="price">5,200원</span></div>
                </div>
                <div class="menu-card" onclick="openDetail(this)"
                     data-name="청포도에이드" data-type="ICE" data-price="5,200원"
                     data-img="https://images.unsplash.com/photo-1560508180-03f285f67ded?w=600&h=400&fit=crop&auto=format"
                     data-story="청명한 초록빛 청포도는 지중해 포도밭에서 수천 년간 재배되어 온 과일입니다. 통통하고 즙이 풍부한 청포도의 달콤하면서도 산뜻한 맛이 탄산과 만나 유리잔 속에서 반짝입니다. 보는 것만으로도 시원함이 느껴지는 청포도에이드는 눈과 입이 동시에 즐거운 음료입니다.">
                    <img src="https://images.unsplash.com/photo-1560508180-03f285f67ded?w=400&h=280&fit=crop&auto=format" alt="청포도에이드" onerror="imgError(this)">
                    <p class="item-name">청포도에이드</p>
                    <p class="item-type">ICE</p>
                    <div class="price-row"><span class="price-label">avg</span><span class="price">5,200원</span></div>
                </div>
                <div class="menu-card" onclick="openDetail(this)"
                     data-name="패션후르츠에이드" data-type="ICE" data-price="5,200원"
                     data-img="https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=600&h=400&fit=crop&auto=format"
                     data-story="브라질의 아마존 밀림에서 처음 발견된 패션후르츠는 탐험가들이 그 꽃의 형태가 예수의 수난(Passion)을 닮았다 하여 이름 붙였습니다. 새콤달콤하면서도 이국적인 향이 가득한 패션후르츠를 탄산과 블렌딩하여 열대 휴양지의 분위기를 한 잔에 담았습니다.">
                    <img src="https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400&h=280&fit=crop&auto=format" alt="패션후르츠에이드" onerror="imgError(this)">
                    <p class="item-name">패션후르츠에이드</p>
                    <p class="item-type">ICE</p>
                    <div class="price-row"><span class="price-label">avg</span><span class="price">5,200원</span></div>
                </div>
            </div>
        </div>

        <div class="sub-category">
            <p class="sub-title">스무디</p>
            <div class="menu-grid">
                <div class="menu-card" onclick="openDetail(this)"
                     data-name="망고스무디" data-type="ICE" data-price="5,650원"
                     data-img="https://images.unsplash.com/photo-1623065422902-30a2d299bbe4?w=600&h=400&fit=crop&auto=format"
                     data-story="인도에서 4,000년 이상 재배된 망고는 '과일의 왕'으로 불립니다. 인도 무굴 황제 악바르는 10만 그루의 망고 나무를 심었다는 기록이 있을 정도입니다. 태국산 옐로망고의 진한 과육을 통째로 블렌딩하여 열대의 달콤함을 그대로 담은 스무디입니다.">
                    <img src="https://images.unsplash.com/photo-1623065422902-30a2d299bbe4?w=400&h=280&fit=crop&auto=format" alt="망고스무디" onerror="imgError(this)">
                    <p class="item-name">망고스무디</p>
                    <p class="item-type">ICE</p>
                    <div class="price-row"><span class="price-label">avg</span><span class="price">5,650원</span></div>
                </div>
                <div class="menu-card" onclick="openDetail(this)"
                     data-name="딸기스무디" data-type="ICE" data-price="5,650원"
                     data-img="https://images.unsplash.com/photo-1579954115545-a95591f28bfc?w=600&h=400&fit=crop&auto=format"
                     data-story="13세기 프랑스 왕실 정원에서 처음 재배된 딸기는 '비너스의 열매'라 불리며 귀족들만의 과일이었습니다. 오늘날 한국의 논산, 담양, 밀양에서 재배되는 국내산 딸기는 세계 최고 품질로 손꼽힙니다. 새콤달콤한 생딸기를 가득 넣어 블렌딩한 스무디로 오늘 하루를 달콤하게 물들여보세요.">
                    <img src="https://images.unsplash.com/photo-1579954115545-a95591f28bfc?w=400&h=280&fit=crop&auto=format" alt="딸기스무디" onerror="imgError(this)">
                    <p class="item-name">딸기스무디</p>
                    <p class="item-type">ICE</p>
                    <div class="price-row"><span class="price-label">avg</span><span class="price">5,650원</span></div>
                </div>
                <div class="menu-card" onclick="openDetail(this)"
                     data-name="블루베리스무디" data-type="ICE" data-price="5,650원"
                     data-img="https://images.unsplash.com/photo-1508869901315-49c557f3969d?w=600&h=400&fit=crop&auto=format"
                     data-story="북미 원주민들이 수천 년 전부터 '위대한 베리'라 부르며 즐겨온 블루베리는 안토시아닌이 풍부한 슈퍼푸드입니다. 신선한 블루베리를 가득 담아 몸도 마음도 건강해지는 스무디입니다.">
                    <img src="https://images.unsplash.com/photo-1508869901315-49c557f3969d?w=400&h=280&fit=crop&auto=format" alt="블루베리스무디" onerror="imgError(this)">
                    <p class="item-name">블루베리스무디</p>
                    <p class="item-type">ICE</p>
                    <div class="price-row"><span class="price-label">avg</span><span class="price">5,650원</span></div>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== 티 ===== -->
    <div id="tea" class="menu-section">
        <h2 class="section-title">Tea</h2>
        <p class="section-sub">티</p>
        <div class="menu-grid">

            <div class="menu-card" onclick="openDetail(this)"
                 data-name="캐모마일" data-type="HOT / ICE" data-price="4,000원"
                 data-img="https://images.unsplash.com/photo-1596343621063-c7a7aaf37aa6?w=600&h=400&fit=crop&auto=format"
                 data-story="고대 이집트에서 태양신 라(Ra)에게 바쳐지던 신성한 꽃, 캐모마일은 3,000년의 역사를 가진 허브입니다. 그리스어 'khamaimelo(땅의 사과)'에서 이름이 유래했습니다. 하루의 마지막, 긴장을 풀어주는 한 잔의 캐모마일이 편안한 밤을 열어드립니다.">
                <img src="https://images.unsplash.com/photo-1596343621063-c7a7aaf37aa6?w=400&h=280&fit=crop&auto=format" alt="캐모마일" onerror="imgError(this)">
                <p class="item-name">캐모마일</p>
                <p class="item-type">HOT / ICE</p>
                <div class="price-row"><span class="price-label">avg</span><span class="price">4,000원</span></div>
            </div>

            <div class="menu-card" onclick="openDetail(this)"
                 data-name="페퍼민트" data-type="HOT / ICE" data-price="4,000원"
                 data-img="https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=600&h=400&fit=crop&auto=format"
                 data-story="그리스 신화에서 강의 신 코키토스의 딸 민테가 님프로 변한 것이 박하라는 전설이 전해집니다. 청량한 멘톨 성분이 입안을 가득 채우며 머리를 맑게 해주는 페퍼민트티는 집중이 필요한 오후에 딱 맞는 음료입니다.">
                <img src="https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=400&h=280&fit=crop&auto=format" alt="페퍼민트" onerror="imgError(this)">
                <p class="item-name">페퍼민트</p>
                <p class="item-type">HOT / ICE</p>
                <div class="price-row"><span class="price-label">avg</span><span class="price">4,000원</span></div>
            </div>

            <div class="menu-card" onclick="openDetail(this)"
                 data-name="얼그레이" data-type="HOT / ICE" data-price="4,000원"
                 data-img="https://images.unsplash.com/photo-1617443020605-d6aa7e968eb3?w=600&h=400&fit=crop&auto=format"
                 data-story="1830년대 영국 총리를 역임한 찰스 그레이 2세 백작의 이름을 딴 얼그레이는 홍차에 베르가못 오렌지 오일을 블렌딩한 티입니다. 플로럴하고 시트러스한 베르가못 향이 영국 귀족의 오후를 연상시키는 클래식한 티입니다.">
                <img src="https://images.unsplash.com/photo-1617443020605-d6aa7e968eb3?w=400&h=280&fit=crop&auto=format" alt="얼그레이" onerror="imgError(this)">
                <p class="item-name">얼그레이</p>
                <p class="item-type">HOT / ICE</p>
                <div class="price-row"><span class="price-label">avg</span><span class="price">4,000원</span></div>
            </div>

            <div class="menu-card" onclick="openDetail(this)"
                 data-name="녹차" data-type="HOT / ICE" data-price="4,000원"
                 data-img="https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=600&h=400&fit=crop&auto=format"
                 data-story="중국 신농 황제가 기원전 2737년 끓는 물에 찻잎이 떨어지며 우연히 발견했다는 전설의 음료입니다. 보성과 하동의 청정한 산자락에서 자란 유기농 찻잎이 선사하는 은은하고 깊은 맛을 느껴보세요.">
                <img src="https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400&h=280&fit=crop&auto=format" alt="녹차" onerror="imgError(this)">
                <p class="item-name">녹차</p>
                <p class="item-type">HOT / ICE</p>
                <div class="price-row"><span class="price-label">avg</span><span class="price">4,000원</span></div>
            </div>

            <div class="menu-card" onclick="openDetail(this)"
                 data-name="루이보스" data-type="HOT / ICE" data-price="4,000원"
                 data-img="https://images.unsplash.com/photo-1597318181412-49af291f617f?w=600&h=400&fit=crop&auto=format"
                 data-story="남아프리카 케이프타운 인근 세더버그 산악지대에서만 자라는 루이보스는 코이코이 원주민들이 수백 년간 즐겨온 허브입니다. 카페인이 전혀 없고 항산화 성분이 풍부하며, 붉은 황토빛 색깔만큼이나 따뜻하고 은은한 단맛이 마음을 편안하게 해줍니다.">
                <img src="https://images.unsplash.com/photo-1597318181412-49af291f617f?w=400&h=280&fit=crop&auto=format" alt="루이보스" onerror="imgError(this)">
                <p class="item-name">루이보스</p>
                <p class="item-type">HOT / ICE</p>
                <div class="price-row"><span class="price-label">avg</span><span class="price">4,000원</span></div>
            </div>

            <div class="menu-card" onclick="openDetail(this)"
                 data-name="유자차" data-type="HOT / ICE" data-price="4,850원"
                 data-img="https://images.unsplash.com/photo-1682530017002-34e2cb7b1653?w=600&h=400&fit=crop&auto=format"
                 data-story="유자는 중국 양쯔강 상류가 원산지인 감귤로, 삼국시대부터 한반도에서 재배된 한국의 대표 전통 과일입니다. 전남 고흥과 경남 거제의 겨울 유자는 레몬보다 3배 이상 많은 비타민 C를 품고 있습니다. 달콤하게 재운 유자청이 따뜻한 물에 녹으면 한옥 마루에 앉아 마시는 겨울 오후의 향이 납니다.">
                <img src="https://images.unsplash.com/photo-1682530017002-34e2cb7b1653?w=400&h=280&fit=crop&auto=format" alt="유자차" onerror="imgError(this)">
                <p class="item-name">유자차</p>
                <p class="item-type">HOT / ICE</p>
                <div class="price-row"><span class="price-label">avg</span><span class="price">4,850원</span></div>
            </div>

            <div class="menu-card" onclick="openDetail(this)"
                 data-name="레몬차" data-type="HOT / ICE" data-price="4,850원"
                 data-img=""
                 data-story="지중해 남부 아말피 해안의 절벽 위 레몬나무에서 시작된 이야기입니다. 뱃사람들이 괴혈병 예방을 위해 레몬을 가득 싣고 항해했던 것처럼, 레몬차는 오래전부터 '건강의 음료'로 자리잡아 왔습니다. 국내산 레몬을 슬라이스하여 꿀과 함께 우린 레몬차 한 잔으로 활력을 충전하세요.">
                <div class="img-placeholder">📷 사진 준비 중</div>
                <p class="item-name">레몬차</p>
                <p class="item-type">HOT / ICE</p>
                <div class="price-row"><span class="price-label">avg</span><span class="price">4,850원</span></div>
            </div>

        </div>
    </div>

    <!-- ===== 블렌디드 / 프라페 ===== -->
    <div id="frappe" class="menu-section">
        <h2 class="section-title">Blended &amp; Frappe</h2>
        <p class="section-sub">블렌디드 / 프라페</p>
        <div class="menu-grid">

            <div class="menu-card" onclick="openDetail(this)"
                 data-name="자바칩프라페" data-type="ICE" data-price="5,850원"
                 data-img="https://images.unsplash.com/photo-1718267050202-9b1b6bfb8545?w=600&h=400&fit=crop&auto=format"
                 data-story="인도네시아 자바(Java) 섬은 세계적으로 유명한 커피 산지입니다. 시원하게 블렌딩된 커피 프라페에 초콜릿 칩의 씹히는 식감이 더해져 카페에서 가장 인기 있는 여름 메뉴가 되었습니다.">
                <img src="https://images.unsplash.com/photo-1718267050202-9b1b6bfb8545?w=400&h=280&fit=crop&auto=format" alt="자바칩프라페" onerror="imgError(this)">
                <p class="item-name">자바칩프라페</p>
                <p class="item-type">ICE</p>
                <div class="price-row"><span class="price-label">avg</span><span class="price">5,850원</span></div>
            </div>

            <div class="menu-card" onclick="openDetail(this)"
                 data-name="쿠키앤크림프라페" data-type="ICE" data-price="5,850원"
                 data-img="https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=600&h=400&fit=crop&auto=format"
                 data-story="1912년 미국 뉴저지에서 탄생한 오레오 쿠키를 시원한 밀크 베이스와 함께 블렌딩하면 어린 시절의 행복한 기억이 살아납니다. 쿠키의 고소함과 크림의 달콤함이 얼음과 함께 어우러진 최고의 여름 디저트 음료입니다.">
                <img src="https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=400&h=280&fit=crop&auto=format" alt="쿠키앤크림프라페" onerror="imgError(this)">
                <p class="item-name">쿠키앤크림프라페</p>
                <p class="item-type">ICE</p>
                <div class="price-row"><span class="price-label">avg</span><span class="price">5,850원</span></div>
            </div>

            <div class="menu-card" onclick="openDetail(this)"
                 data-name="망고프라페" data-type="ICE" data-price="5,650원"
                 data-img="https://images.unsplash.com/photo-1546173159-315724a31696?w=600&h=400&fit=crop&auto=format"
                 data-story="태국 치앙마이의 황금빛 망고밭에서 직수입한 남독마이 망고는 '망고 중의 망고'로 불립니다. 섬유질 없이 부드럽고 꿀처럼 달콤한 과육을 얼음과 함께 블렌딩하면 열대 리조트 수영장 옆에 앉아 있는 듯한 기분이 듭니다.">
                <img src="https://images.unsplash.com/photo-1546173159-315724a31696?w=400&h=280&fit=crop&auto=format" alt="망고프라페" onerror="imgError(this)">
                <p class="item-name">망고프라페</p>
                <p class="item-type">ICE</p>
                <div class="price-row"><span class="price-label">avg</span><span class="price">5,650원</span></div>
            </div>

        </div>
    </div>

    <!-- ===== 디저트 & 푸드 ===== -->
    <div id="dessert" class="menu-section">
        <h2 class="section-title">Dessert &amp; Food</h2>
        <p class="section-sub">디저트 &amp; 푸드</p>

        <div class="sub-category">
            <p class="sub-title">케이크</p>
            <div class="menu-grid">
                <div class="menu-card" onclick="openDetail(this)"
                     data-name="치즈케이크" data-type="Cake" data-price="6,500원"
                     data-img="https://images.unsplash.com/photo-1702925614886-50ad13c88d3f?w=600&h=400&fit=crop&auto=format"
                     data-story="치즈케이크의 역사는 기원전 776년 고대 그리스 올림픽으로 거슬러 올라갑니다. 덴마크산 크림치즈를 듬뿍 사용해 진하고 부드러운 질감을 완성한 당신만을 위한 치즈케이크입니다.">
                    <img src="https://images.unsplash.com/photo-1702925614886-50ad13c88d3f?w=400&h=280&fit=crop&auto=format" alt="치즈케이크" onerror="imgError(this)">
                    <p class="item-name">치즈케이크</p>
                    <p class="item-type">Cake</p>
                    <div class="price-row"><span class="price-label">avg</span><span class="price">6,500원</span></div>
                </div>
                <div class="menu-card" onclick="openDetail(this)"
                     data-name="티라미수" data-type="Cake" data-price="6,500원"
                     data-img=""
                     data-story="티라미수(Tiramisù)는 이탈리아어로 '나를 들어올려줘(Pick me up)'라는 뜻입니다. 마스카르포네 치즈, 에스프레소에 적신 레이디핑거, 코코아 파우더가 층을 이루는 이 디저트는 첫 한 숟가락에 기분이 들뜨는 마법 같은 케이크입니다.">
                    <div class="img-placeholder">📷 사진 준비 중</div>
                    <p class="item-name">티라미수</p>
                    <p class="item-type">Cake</p>
                    <div class="price-row"><span class="price-label">avg</span><span class="price">6,500원</span></div>
                </div>
                <div class="menu-card" onclick="openDetail(this)"
                     data-name="초코케이크" data-type="Cake" data-price="6,500원"
                     data-img="https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600&h=400&fit=crop&auto=format"
                     data-story="발로나 다크 초콜릿으로 만든 가나슈를 층층이 쌓아 올린 진한 초코케이크는 초콜릿 애호가들의 로망입니다.">
                    <img src="https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400&h=280&fit=crop&auto=format" alt="초코케이크" onerror="imgError(this)">
                    <p class="item-name">초코케이크</p>
                    <p class="item-type">Cake</p>
                    <div class="price-row"><span class="price-label">avg</span><span class="price">6,500원</span></div>
                </div>
                <div class="menu-card" onclick="openDetail(this)"
                     data-name="당근케이크" data-type="Cake" data-price="6,500원"
                     data-img=""
                     data-story="중세 유럽에서 설탕이 귀했던 시절, 달콤한 당근이 설탕의 대체재로 사용되며 탄생했습니다. 촉촉한 당근 케이크 위에 크림치즈 프로스팅을 듬뿍 올린 우리의 당근케이크는 그 역사의 정점입니다.">
                    <div class="img-placeholder">📷 사진 준비 중</div>
                    <p class="item-name">당근케이크</p>
                    <p class="item-type">Cake</p>
                    <div class="price-row"><span class="price-label">avg</span><span class="price">6,500원</span></div>
                </div>
                <div class="menu-card" onclick="openDetail(this)"
                     data-name="딸기케이크" data-type="Cake" data-price="7,000원"
                     data-img=""
                     data-story="폭신한 제누아즈 시트 사이에 신선한 생크림과 국내산 생딸기를 겹겹이 쌓아 올린 이 케이크는 보는 것만으로도 특별한 날이 된 기분을 선사합니다.">
                    <div class="img-placeholder">📷 사진 준비 중</div>
                    <p class="item-name">딸기케이크</p>
                    <p class="item-type">Cake</p>
                    <div class="price-row"><span class="price-label">avg</span><span class="price">7,000원</span></div>
                </div>
            </div>
        </div>

        <div class="sub-category">
            <p class="sub-title">빵 / 베이커리</p>
            <div class="menu-grid">
                <div class="menu-card" onclick="openDetail(this)"
                     data-name="크로와상" data-type="Bakery" data-price="3,600원"
                     data-img="https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=600&h=400&fit=crop&auto=format"
                     data-story="1683년 오스만 제국의 빈 포위 작전을 기념해 오스트리아 제빵사가 초승달 모양으로 만든 것이 크로와상의 기원입니다. 결 따라 바삭하게 부서지는 그 황홀함을 느껴보세요.">
                    <img src="https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=400&h=280&fit=crop&auto=format" alt="크로와상" onerror="imgError(this)">
                    <p class="item-name">크로와상</p>
                    <p class="item-type">Bakery</p>
                    <div class="price-row"><span class="price-label">avg</span><span class="price">3,600원</span></div>
                </div>
                <div class="menu-card" onclick="openDetail(this)"
                     data-name="스콘" data-type="Bakery" data-price="3,400원"
                     data-img=""
                     data-story="스코틀랜드의 스콘 마을에서 이름을 딴 스콘은 16세기부터 사랑받던 소박한 빵입니다. 잼과 함께라면 더할 나위 없는 오후의 동반자입니다.">
                    <div class="img-placeholder">📷 사진 준비 중</div>
                    <p class="item-name">스콘</p>
                    <p class="item-type">Bakery</p>
                    <div class="price-row"><span class="price-label">avg</span><span class="price">3,400원</span></div>
                </div>
                <div class="menu-card" onclick="openDetail(this)"
                     data-name="머핀" data-type="Bakery" data-price="3,400원"
                     data-img="https://images.unsplash.com/photo-1607958996333-41aef7caefaa?w=600&h=400&fit=crop&auto=format"
                     data-story="18세기 영국 찻집에서 처음 등장한 머핀은 미국으로 건너가 오늘날의 형태가 되었습니다. 바삭한 겉면과 촉촉한 속이 매력인 머핀은 간단한 아침식사나 오후 간식으로 완벽합니다.">
                    <img src="https://images.unsplash.com/photo-1607958996333-41aef7caefaa?w=400&h=280&fit=crop&auto=format" alt="머핀" onerror="imgError(this)">
                    <p class="item-name">머핀</p>
                    <p class="item-type">Bakery</p>
                    <div class="price-row"><span class="price-label">avg</span><span class="price">3,400원</span></div>
                </div>
                <div class="menu-card" onclick="openDetail(this)"
                     data-name="베이글" data-type="Bakery" data-price="3,150원"
                     data-img=""
                     data-story="17세기 폴란드 크라쿠프의 유대인 공동체에서 탄생한 베이글은 이민의 역사를 담은 빵입니다. 끓는 물에 데친 후 구워 완성되는 독특한 방식이 쫄깃하고 윤기 있는 특유의 식감을 만들어냅니다.">
                    <div class="img-placeholder">📷 사진 준비 중</div>
                    <p class="item-name">베이글</p>
                    <p class="item-type">Bakery</p>
                    <div class="price-row"><span class="price-label">avg</span><span class="price">3,150원</span></div>
                </div>
                <div class="menu-card" onclick="openDetail(this)"
                     data-name="소금빵" data-type="Bakery" data-price="3,050원"
                     data-img=""
                     data-story="일본 에히메현의 '판야 요시다'에서 2013년 탄생한 시오빵이 소금빵의 원조입니다. 버터를 가득 품은 반죽 위에 굵은 소금을 뿌려 구우면 바삭한 겉면 안에서 버터가 녹아 흘러내립니다.">
                    <div class="img-placeholder">📷 사진 준비 중</div>
                    <p class="item-name">소금빵</p>
                    <p class="item-type">Bakery</p>
                    <div class="price-row"><span class="price-label">avg</span><span class="price">3,050원</span></div>
                </div>
            </div>
        </div>

        <div class="sub-category">
            <p class="sub-title">간식</p>
            <div class="menu-grid">
                <div class="menu-card" onclick="openDetail(this)"
                     data-name="마카롱" data-type="Snack" data-price="3,050원"
                     data-img="https://images.unsplash.com/photo-1558326567-98ae2405596b?w=600&h=400&fit=crop&auto=format"
                     data-story="마카롱의 역사는 8세기 이탈리아 수도원에서 시작됩니다. 19세기 파리의 라뒤레(Ladurée)에서 두 개의 쿠키 사이에 크림을 채운 현재의 형태가 완성되었습니다. 0.1mm 두께의 차이도 용납하지 않는 파티시에의 손길로 완성된 한 입의 예술작품입니다.">
                    <img src="https://images.unsplash.com/photo-1558326567-98ae2405596b?w=400&h=280&fit=crop&auto=format" alt="마카롱" onerror="imgError(this)">
                    <p class="item-name">마카롱</p>
                    <p class="item-type">Snack</p>
                    <div class="price-row"><span class="price-label">avg</span><span class="price">3,050원</span></div>
                </div>
                <div class="menu-card" onclick="openDetail(this)"
                     data-name="쿠키" data-type="Snack" data-price="2,800원"
                     data-img="https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=600&h=400&fit=crop&auto=format"
                     data-story="버터의 고소함이 가득 밴 반죽에 벨기에산 초콜릿 칩을 아낌없이 넣어 구운 쿠키는 커피 한 잔과 함께하는 가장 완벽한 조합입니다.">
                    <img src="https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=400&h=280&fit=crop&auto=format" alt="쿠키" onerror="imgError(this)">
                    <p class="item-name">쿠키</p>
                    <p class="item-type">Snack</p>
                    <div class="price-row"><span class="price-label">avg</span><span class="price">2,800원</span></div>
                </div>
                <div class="menu-card" onclick="openDetail(this)"
                     data-name="휘낭시에" data-type="Snack" data-price="2,750원"
                     data-img="https://images.unsplash.com/photo-1519676867240-f03562e64548?w=600&h=400&fit=crop&auto=format"
                     data-story="19세기 파리 증권거래소 근처에서 정장을 입은 금융가들이 양복에 묻히지 않고 먹을 수 있도록 금괴 모양으로 만든 것이 유래입니다. 버터를 태운 뵈르 누아제트의 고소한 향이 이 작은 과자를 특별하게 만듭니다.">
                    <img src="https://images.unsplash.com/photo-1519676867240-f03562e64548?w=400&h=280&fit=crop&auto=format" alt="휘낭시에" onerror="imgError(this)">
                    <p class="item-name">휘낭시에</p>
                    <p class="item-type">Snack</p>
                    <div class="price-row"><span class="price-label">avg</span><span class="price">2,750원</span></div>
                </div>
                <div class="menu-card" onclick="openDetail(this)"
                     data-name="브라우니" data-type="Snack" data-price="3,150원"
                     data-img="https://images.unsplash.com/photo-1515037893149-de7f840978e2?w=600&h=400&fit=crop&auto=format"
                     data-story="1893년 시카고 만국박람회를 앞두고 탄생했다는 설이 전해집니다. 겉은 바삭하고 속은 촉촉한 진한 초콜릿의 풍미가 가득합니다.">
                    <img src="https://images.unsplash.com/photo-1515037893149-de7f840978e2?w=400&h=280&fit=crop&auto=format" alt="브라우니" onerror="imgError(this)">
                    <p class="item-name">브라우니</p>
                    <p class="item-type">Snack</p>
                    <div class="price-row"><span class="price-label">avg</span><span class="price">3,150원</span></div>
                </div>
                <div class="menu-card" onclick="openDetail(this)"
                     data-name="마들렌" data-type="Snack" data-price="2,750원"
                     data-img="https://images.unsplash.com/photo-1586985289688-ca3cf47d3e6e?w=600&h=400&fit=crop&auto=format"
                     data-story="프루스트의 소설 '잃어버린 시간을 찾아서'에서 유명해진 이 조개 모양의 작은 케이크는 레몬 향이 은은하게 풍기며 추억을 소환하는 마법을 부립니다.">
                    <img src="https://images.unsplash.com/photo-1586985289688-ca3cf47d3e6e?w=400&h=280&fit=crop&auto=format" alt="마들렌" onerror="imgError(this)">
                    <p class="item-name">마들렌</p>
                    <p class="item-type">Snack</p>
                    <div class="price-row"><span class="price-label">avg</span><span class="price">2,750원</span></div>
                </div>
            </div>
        </div>

        <div class="sub-category">
            <p class="sub-title">브런치</p>
            <div class="menu-grid">
                <div class="menu-card" onclick="openDetail(this)"
                     data-name="에그샌드위치" data-type="Brunch" data-price="4,750원"
                     data-img="https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=600&h=400&fit=crop&auto=format"
                     data-story="국내산 신선한 달걀을 부드럽게 스크램블한 에그 샐러드를 두툼한 식빵 사이에 가득 담아 완성한 당신의 든든한 아침입니다.">
                    <img src="https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=400&h=280&fit=crop&auto=format" alt="에그샌드위치" onerror="imgError(this)">
                    <p class="item-name">에그샌드위치</p>
                    <p class="item-type">Brunch</p>
                    <div class="price-row"><span class="price-label">avg</span><span class="price">4,750원</span></div>
                </div>
                <div class="menu-card" onclick="openDetail(this)"
                     data-name="BLT샌드위치" data-type="Brunch" data-price="4,900원"
                     data-img="https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=600&h=400&fit=crop&auto=format"
                     data-story="바삭하게 구운 베이컨, 신선한 로메인 상추, 완숙 토마토를 듬뿍 넣고 마요네즈로 마무리한 간단하지만 완벽한 한 끼입니다.">
                    <img src="https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&h=280&fit=crop&auto=format" alt="BLT샌드위치" onerror="imgError(this)">
                    <p class="item-name">BLT샌드위치</p>
                    <p class="item-type">Brunch</p>
                    <div class="price-row"><span class="price-label">avg</span><span class="price">4,900원</span></div>
                </div>
                <div class="menu-card" onclick="openDetail(this)"
                     data-name="크로크무슈" data-type="Brunch" data-price="5,150원"
                     data-img="https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=600&h=400&fit=crop&auto=format"
                     data-story="1910년 파리의 한 카페 메뉴에 처음 등장한 크로크무슈는 프랑스 전역의 비스트로와 카페에서 필수 메뉴가 되었습니다. 햄과 그뤼에르 치즈를 베샤멜 소스와 함께 구운 파리지앵의 점심입니다.">
                    <img src="https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400&h=280&fit=crop&auto=format" alt="크로크무슈" onerror="imgError(this)">
                    <p class="item-name">크로크무슈</p>
                    <p class="item-type">Brunch</p>
                    <div class="price-row"><span class="price-label">avg</span><span class="price">5,150원</span></div>
                </div>
                <div class="menu-card" onclick="openDetail(this)"
                     data-name="토스트" data-type="Brunch" data-price="3,800원"
                     data-img="https://images.unsplash.com/photo-1484723091739-30a097e8f929?w=600&h=400&fit=crop&auto=format"
                     data-story="갓 구운 식빵의 따뜻한 온기와 버터가 녹아드는 순간의 소박한 행복을 담은 토스트는 언제나 옳은 선택입니다.">
                    <img src="https://images.unsplash.com/photo-1484723091739-30a097e8f929?w=400&h=280&fit=crop&auto=format" alt="토스트" onerror="imgError(this)">
                    <p class="item-name">토스트</p>
                    <p class="item-type">Brunch</p>
                    <div class="price-row"><span class="price-label">avg</span><span class="price">3,800원</span></div>
                </div>
                <div class="menu-card" onclick="openDetail(this)"
                     data-name="샐러드" data-type="Brunch" data-price="5,000원"
                     data-img="https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600&h=400&fit=crop&auto=format"
                     data-story="제철 유기농 채소와 견과류, 신선한 드레싱으로 구성된 우리의 샐러드는 가볍지만 충분한 한 끼를 약속합니다.">
                    <img src="https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=280&fit=crop&auto=format" alt="샐러드" onerror="imgError(this)">
                    <p class="item-name">샐러드</p>
                    <p class="item-type">Brunch</p>
                    <div class="price-row"><span class="price-label">avg</span><span class="price">5,000원</span></div>
                </div>
            </div>
        </div>
    </div>

</div>

<!-- 상세 모달 -->
<div id="detail-modal" class="modal-overlay">
    <div class="modal-box">
        <button class="modal-close" onclick="closeDetail()">&#x2715;</button>
        <img id="modal-img" class="modal-img" src="" alt="">
        <div id="modal-img-placeholder" class="modal-img-placeholder" style="display:none">
            <span>📷</span>
            <span>사진 준비 중</span>
        </div>
        <div class="modal-body">
            <p id="modal-tag" class="modal-tag"></p>
            <h2 id="modal-name" class="modal-name"></h2>
            <p id="modal-story" class="modal-story"></p>
            <div class="modal-footer">
                <span id="modal-price" class="modal-price"></span>
                <button class="btn-buy" onclick="showComingSoon()">구매하기</button>
            </div>
        </div>
    </div>
</div>

<!-- 준비중 모달 -->
<div id="coming-soon-modal" class="modal-overlay">
    <div class="modal-box small">
        <p>준비 중입니다</p>
        <span>곧 만나볼 수 있어요 :)</span>
        <button class="btn-confirm" onclick="closeComingSoon()">확인</button>
    </div>
</div>

<script src="${pageContext.request.contextPath}/resources/js/menu.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/detail.js"></script>

<%@ include file="../common/footer.jsp" %>
