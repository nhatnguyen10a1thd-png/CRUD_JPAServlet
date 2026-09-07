package nguyen.vn.crud_jpaservlet.config;

import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;

/**
 * SiteMesh filter configuration.
 * Applies the main decorator layout to pages served from /WEB-INF/views/,
 * while excluding standalone pages like login, register, etc.
 */
public class SiteMeshFilter extends ConfigurableSiteMeshFilter {

    @Override
    protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
        // Main decorator for authenticated pages
        builder.addDecoratorPath("/*", "/main-layout.jsp");

        // Exclude pages that have their own standalone layout (match by request URL, not JSP path)
        builder.addExcludedPath("/login")
                .addExcludedPath("/logout")
                .addExcludedPath("/register")
                .addExcludedPath("/forgot-password")
                .addExcludedPath("/verify-otp")
                .addExcludedPath("/verify-reset-otp")
                .addExcludedPath("/reset-password")
                .addExcludedPath("/reset-success")
                .addExcludedPath("/register-success")
                .addExcludedPath("/image")
                .addExcludedPath("/assets/*");
    }
}
