# 概述

cas client用于部署在应用中，与cas server交互实现单点登录功能，每个需要实现单点登录的应用均需要部署cas client。出于达到对后期快速开发的目的，我在研究cas server的同时，也基于cas官方提供的client模板[JA-SIG Java Client Simple WebApp Sample](https://wiki.jasig.org/display/CASC/JA-SIG+Java+Client+Simple+WebApp+Sample)对cas client进行配置和封装出一套部署包，该套部署包需要与[cas server部署包](https://github.com/Strangeen/cas-server-4.2.x-deployment-package)同时使用


# Quick Start

该部署包使用Eclipse配置开发，可以直接使用Eclipse导入后运行，下面提供快速开始方法：

1. 部署部署包中文件夹`/WebContent/`中的文件到tomcat的`webapps/mywebapp/`下

2. 复制部署包文件夹`/source/`中的文件`log4j2.xml`到`webapps/mywebapp/WEB-INF/classes/`下

3. 配置`/WEB-INF/web.xml`：
    
    - 配置`context-param`：
    
        1. **cas server部署的网站根目录地址**
    	    ```xml
        	<context-param>
                <param-name>serverName</param-name>
                <param-value>http://localhost:8081</param-value>
        	</context-param>
        	```
        	- `<param-value>`配置为cas server部署网站根目录地址，如果cas server部署在`http://localhost:8081/cas`下，那么该值配置为`http://localhost:8081`
    
        2. **cas server部署地址**
            ```xml
        	<context-param>
                <param-name>casServerUrlPrefix</param-name>
                <param-value>http://localhost:8081/cas</param-value>
        	</context-param>
        	```
        	- `<param-value>`配置为cas server部署网站地址，如果cas server部署在`http://localhost:8081/cas`下，那么该值配置为`http://localhost:8081/cas`
    	
        3. **cas server登录地址**
            ```xml
            <context-param>
                <param-name>casServerLoginUrl</param-name>
                <param-value>http://localhost:8081/cas/login</param-value>
        	</context-param>
        	```
        	- `<param-value>`配置为cas server登录地址
    
    - 配置需要登陆才能访问的地址
        ```
        ...
        <filter-name>CAS Authentication Filter</filter-name>
        <url-pattern>/protected/*</url-pattern>
        ...
        ```
        - `<url-pattern>`配置为需要登录才能访问的地址，默认为`/protected/*`，当访问`/protected/*`是会跳转到cas server要求登陆

基本配置完成，启动tomcat即可通过`http://your-deployment-url/mywebapp`访问cas client，访问`localhost/mywebapp/protected`需要同时开启cas server，cas server部署包和配置参见：[cas server部署包](https://github.com/Strangeen/cas-server-4.2.x-deployment-package)

* 注：*.log文件默认保存位置配置到`D:/cas_client/logs/`下（linux请更改为`/cas_client/logs`，否则可能无法启动），如需配置见`更多配置`的`3. 日志配置`

---

# 更多配置

### 1. context-param配置

- #### 描述
    环境参数配置用于filter的参数，由于多个filter拥有相同参数，cas client支持读取环境参数来配置，因此将各个filter重复的参数配置为环境参数

- #### 配置
	
	见`Quick Start`第3点中`配置context-param`：

### 1. Filter配置

- #### 描述
    cas client配置filter用于与cas server交互，主要有5类filter，并且配置需要按如下顺序进行配置，否则无法正常使用：

    SingleSignOutFilter，AuthenticationFilter，TicketValidationFilter，HttpServletRequestWrapperFilter，AssertionThreadLocalFilter

- #### 配置
    
    1. ##### SingleSignOutFilter（默认已配置）
        
        控制单点登出，当cas server退出后，会发送请求要求cas client清楚登录session，请求由该filter处理
        ```xml
        <filter>
    		<filter-name>CAS Single Sign Out Filter</filter-name>
    		<filter-class>org.jasig.cas.client.session.SingleSignOutFilter</filter-class>
    	</filter>
    	<filter-mapping>
    		<filter-name>CAS Single Sign Out Filter</filter-name>
    		<url-pattern>/*</url-pattern>
    	</filter-mapping>
        ```

    1. ##### AuthenticationFilter（默认已配置，参数需要自行设置）
    
        验证用户是否登陆，如果没有登录，就会重定向到cas server，进行登录操作，如果已经登陆，就会获取ST，配置如下：
        ```xml
        <filter>
            <filter-name>CAS Authentication Filter</filter-name>
            <filter-class>org.jasig.cas.client.authentication.AuthenticationFilter</filter-class>
            <filter-mapping>
                <filter-name>CAS Authentication Filter</filter-name>
                <url-pattern>/protected/*</url-pattern>
            </filter-mapping>
        </filter>
        ```
        - `<url-pattern>`配置为需要登录才能访问的地址

    2. ###### TicketValidationFilter（默认已配置）
    
        用于验证ST，默认配置使用cas protocol3.0验证，即`Cas30TicketValidationFilter`
        ```xml
        <filter>
            <filter-name>CAS Validation Filter</filter-name>
            <filter-class>org.jasig.cas.client.validation.Cas30ProxyReceivingTicketValidationFilter</filter-class>
        </filter>
        <filter-mapping>
            <filter-name>CAS Validation Filter</filter-name>
            <url-pattern>/*</url-pattern>
        </filter-mapping>
        ```
    
    3. ###### HttpServletRequestWrapperFilter（默认已配置）
        
        cas封装的HttpServletRequest，通过 `getRemoteUser` 和 `getPrincipal` 方法返回Pincipal信息
        ```xml
        <filter>
            <filter-name>CAS HttpServletRequest Wrapper Filter</filter-name>
            <filter-class>org.jasig.cas.client.util.HttpServletRequestWrapperFilter</filter-class>
        </filter>
        <filter-mapping>
            <filter-name>CAS HttpServletRequest Wrapper Filter</filter-name>
            <url-pattern>/*</url-pattern>
        </filter-mapping>
        ```
    
    4. ###### AssertionThreadLocalFilter（默认已配置）
    
        将Principal信息放入ThreadLocal中，便于无法使用request的方法获取Principal信息
        ```xml
        <filter>
            <filter-name>CAS Assertion Thread Local Filter</filter-name>
            <filter-class>org.jasig.cas.client.util.AssertionThreadLocalFilter</filter-class>
        </filter>
        <filter-mapping>
            <filter-name>CAS Assertion Thread Local Filter</filter-name>
            <url-pattern>/*</url-pattern>
        </filter-mapping>
        ```

filter更多参数配置请参见官方文档：[Configuring the Jasig CAS Client for Java in the web.xml](https://wiki.jasig.org/display/CASC/Configuring+the+Jasig+CAS+Client+for+Java+in+the+web.xml)

### 2. Listener配置
    默认已配置，用于cas client的session失效后，清除记录的用于与cas server交互的TGT信息
    ```
    <listener>
        <listener-class>org.jasig.cas.client.session.SingleSignOutHttpSessionListener</listener-class>
	</listener>
	```

### 3. 日志文件位置

- `log4j2.xml`

    默认`/WEB-INF/classes/`下，配置参见：[cas-server-4.2.x-deployment-package - 4. /WEB-INF/classes/log4j2.xml](https://github.com/Strangeen/cas-server-4.2.x-deployment-package#4-web-infclasseslog4j2xml)

- `*.log`

    默认`D:/cas_client/logs/`下，配置参见：[cas-server-4.2.x-deployment-package - 5. /WEB-INF/logs/*.log](https://github.com/Strangeen/cas-server-4.2.x-deployment-package#5-web-inflogslog)

