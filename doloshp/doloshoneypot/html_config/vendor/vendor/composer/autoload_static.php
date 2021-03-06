<?php

// autoload_static.php @generated by Composer

namespace Composer\Autoload;

class ComposerStaticInit10f4af78fc9daef1d6082fd6563b65c3
{
    public static $files = array (
        'a16312f9300fed4a097923eacb0ba814' => __DIR__ . '/..' . '/igorw/get-in/src/get_in.php',
    );

    public static $prefixLengthsPsr4 = array (
        'Z' => 
        array (
            'Zend\\Diactoros\\' => 15,
        ),
        'S' => 
        array (
            'Symfony\\Component\\PropertyAccess\\' => 33,
        ),
        'P' => 
        array (
            'Psr\\Http\\Message\\' => 17,
        ),
        'M' => 
        array (
            'MaxMind\\' => 8,
        ),
        'I' => 
        array (
            'Ivory\\JsonBuilder\\' => 18,
            'Ivory\\HttpAdapter\\' => 18,
            'Ivory\\GoogleMap\\' => 16,
        ),
        'H' => 
        array (
            'Http\\Promise\\' => 13,
            'Http\\Client\\' => 12,
        ),
        'G' => 
        array (
            'GeoIp2\\' => 7,
        ),
    );

    public static $prefixDirsPsr4 = array (
        'Zend\\Diactoros\\' => 
        array (
            0 => __DIR__ . '/..' . '/zendframework/zend-diactoros/src',
        ),
        'Symfony\\Component\\PropertyAccess\\' => 
        array (
            0 => __DIR__ . '/..' . '/symfony/property-access',
        ),
        'Psr\\Http\\Message\\' => 
        array (
            0 => __DIR__ . '/..' . '/psr/http-message/src',
        ),
        'MaxMind\\' => 
        array (
            0 => __DIR__ . '/..' . '/maxmind/web-service-common/src',
        ),
        'Ivory\\JsonBuilder\\' => 
        array (
            0 => __DIR__ . '/..' . '/egeloen/json-builder/src',
        ),
        'Ivory\\HttpAdapter\\' => 
        array (
            0 => __DIR__ . '/..' . '/egeloen/http-adapter/src',
        ),
        'Ivory\\GoogleMap\\' => 
        array (
            0 => __DIR__ . '/..' . '/egeloen/google-map/src',
        ),
        'Http\\Promise\\' => 
        array (
            0 => __DIR__ . '/..' . '/php-http/promise/src',
        ),
        'Http\\Client\\' => 
        array (
            0 => __DIR__ . '/..' . '/php-http/httplug/src',
        ),
        'GeoIp2\\' => 
        array (
            0 => __DIR__ . '/..' . '/geoip2/geoip2/src',
        ),
    );

    public static $prefixesPsr0 = array (
        'W' => 
        array (
            'Widop\\HttpAdapter' => 
            array (
                0 => __DIR__ . '/..' . '/widop/http-adapter/src',
            ),
        ),
        'M' => 
        array (
            'MaxMind' => 
            array (
                0 => __DIR__ . '/..' . '/maxmind-db/reader/src',
            ),
        ),
        'G' => 
        array (
            'Geocoder' => 
            array (
                0 => __DIR__ . '/..' . '/willdurand/geocoder/src',
            ),
        ),
    );

    public static function getInitializer(ClassLoader $loader)
    {
        return \Closure::bind(function () use ($loader) {
            $loader->prefixLengthsPsr4 = ComposerStaticInit10f4af78fc9daef1d6082fd6563b65c3::$prefixLengthsPsr4;
            $loader->prefixDirsPsr4 = ComposerStaticInit10f4af78fc9daef1d6082fd6563b65c3::$prefixDirsPsr4;
            $loader->prefixesPsr0 = ComposerStaticInit10f4af78fc9daef1d6082fd6563b65c3::$prefixesPsr0;

        }, null, ClassLoader::class);
    }
}
