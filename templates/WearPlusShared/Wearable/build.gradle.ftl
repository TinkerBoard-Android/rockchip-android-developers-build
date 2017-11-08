<#--
 Copyright 2014 The Android Open Source Project

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
-->
buildscript {
    repositories {
        maven {
            url 'https://maven.google.com'
        }
        jcenter()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:3.0.0'
    }
}

apply plugin: 'com.android.application'

repositories {
    jcenter()
    maven {
        url 'https://maven.google.com'
    }
<#if sample.repository?has_content>
    <#list sample.repository as rep>
    ${rep}
    </#list>
</#if>
}

dependencies {
<#list sample.dependency_wearable as dep>
    <#-- Output dependency after checking if it is a play services depdency and
    needs the latest version number attached. -->
    <@update_play_services_dependency dep="${dep}" />
</#list>
    compile ${play_services_wearable_dependency}
    compile ${android_support_v13_dependency}

    <#if sample.preview_wearable_support_provided_dependency?? && sample.preview_wearable_support_provided_dependency?has_content>
    provided '${sample.preview_wearable_support_provided_dependency}'
    <#else>
    provided ${wearable_support_provided_dependency}
    </#if>

    <#if sample.preview_wearable_support_dependency?? && sample.preview_wearable_support_dependency?has_content>
    compile '${sample.preview_wearable_support_dependency}'
    <#else>
    compile ${wearable_support_dependency}
    </#if>

    compile project(':Shared')
}

// The sample build uses multiple directories to
// keep boilerplate and common code separate from
// the main sample code.
List<String> dirs = [
    'main',     // main sample code; look here for the interesting stuff.
    'common',   // components that are reused by multiple samples
    'template'] // boilerplate code that is generated by the sample template process

android {

      <#if sample.compileSdkVersionWear?? && sample.compileSdkVersionWear?has_content>
        compileSdkVersion ${sample.compileSdkVersionWear}
      <#else>
        compileSdkVersion ${compile_sdk}
      </#if>

    buildToolsVersion ${build_tools_version}

    defaultConfig {
        versionCode 1
        versionName "1.0"

      <#if sample.minSdkVersionWear?? && sample.minSdkVersionWear?has_content>
        minSdkVersion ${sample.minSdkVersionWear}
      <#else>
        minSdkVersion ${min_sdk}
      </#if>

      <#if sample.targetSdkVersionWear?? && sample.targetSdkVersionWear?has_content>
        targetSdkVersion ${sample.targetSdkVersionWear}
      <#else>
        targetSdkVersion ${compile_sdk}
      </#if>

       <#if sample.multiDexEnabled?? && sample.multiDexEnabled?has_content>
         multiDexEnabled ${sample.multiDexEnabled}
       </#if>

    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_7
        targetCompatibility JavaVersion.VERSION_1_7
    }

    sourceSets {
        main {
            dirs.each { dir ->
<#noparse>
                java.srcDirs "src/${dir}/java"
                res.srcDirs "src/${dir}/res"
</#noparse>
            }
        }
        androidTest.setRoot('tests')
        androidTest.java.srcDirs = ['tests/src']

<#if sample.defaultConfig?has_content>
        defaultConfig {
        ${sample.defaultConfig}
        }
<#else>
</#if>
    }
}
