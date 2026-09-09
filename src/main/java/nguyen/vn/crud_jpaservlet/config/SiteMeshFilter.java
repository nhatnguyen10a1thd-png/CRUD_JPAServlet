package nguyen.vn.crud_jpaservlet.config;

import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;

/**
 * SiteMesh filter configuration.
 * Applies the single Bootstrap decorator template (/bootstrap.jsp) to all pages,
 * excluding only static assets and raw image streams.
 */
public class SiteMeshFilter extends ConfigurableSiteMeshFilter {

    @Override
    protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
        // Single Bootstrap template for ALL pages
        builder.addDecoratorPath("/*", "/bootstrap.jsp");

        // Only exclude raw image stream and static assets from decoration
        builder.addExcludedPath("/image")
                .addExcludedPath("/assets/*");
    }
}
