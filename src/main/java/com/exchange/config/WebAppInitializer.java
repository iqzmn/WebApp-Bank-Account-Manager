package com.exchange.config;

import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

import javax.servlet.MultipartConfigElement;
import javax.servlet.ServletRegistration;

public class WebAppInitializer extends AbstractAnnotationConfigDispatcherServletInitializer{


    // Load  spring security configuration
    @Override
    protected Class<?>[] getRootConfigClasses() {
        return new Class[] {AppConfig.class, WebSecurityConfig.class};
    }

    // Load spring web configuration
    @Override
    protected Class<?>[] getServletConfigClasses() {
        return null;
    }

    @Override
    protected String[] getServletMappings() {
        return new String[] {"/"};
    }

    @Override
    protected void customizeRegistration(ServletRegistration.Dynamic registration) {
        registration.setMultipartConfig(getMultipartConfigElement());
    }

    private MultipartConfigElement getMultipartConfigElement(){
        return new MultipartConfigElement(LOCATION, MAX_FILE_SIZE, MAX_REQUEST_SIZE, FILE_SIZE_THRESHOLD);
    }

    /**LOCATION is used to store files temporarily while the parts are processed or when the size
     * of the file exceeds the specified fileSizeThreshold setting
     * */
    private static final String LOCATION = "";

    private static final long MAX_FILE_SIZE = 1024 * 1024;//1MB

    private static final long MAX_REQUEST_SIZE = 1024 * 1024;

    private static final int FILE_SIZE_THRESHOLD = 0;
}
