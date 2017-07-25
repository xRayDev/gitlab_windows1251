# Gitlab windows1251 issue fix

## Current FIX
Version Gitlab **9.4.0**

#### encoding_helper.rb
* Source file: [encoding_helper.rb](https://github.com/xRayDev/gitlab_windows1251/blob/6abac2e77d4e4060ec9dcd12c55fd9a2845c211d/encoding_helper.rb)
* Path (on the file system): /opt/gitlab/embedded/service/gitlab-rails/lib/gitlab/**encoding_helper.rb**
* **Fix:** https://github.com/xRayDev/gitlab_windows1251/commit/51120d37d72514f6bf8cc46a58b31d042393ce3b#diff-c8cc55e6dc0de3038e6e5875cc74197c
* Link to a source file in the repository Gitlab: [encoding_helper.rb](https://gitlab.com/gitlab-org/gitlab-ce/blob/master/lib/gitlab/encoding_helper.rb)

#### grit_ext.rb
* Source file: [grit_ext.rb](https://github.com/xRayDev/gitlab_windows1251/blob/6abac2e77d4e4060ec9dcd12c55fd9a2845c211d/grit_ext.rb)
* Path (on the file system): /opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/gitlab-grit-2.8.1/lib/**grit_ext.rb**
* **Fix:** https://github.com/xRayDev/gitlab_windows1251/commit/51120d37d72514f6bf8cc46a58b31d042393ce3b#diff-e55f3c175cd7224582f98cacd85da9ca
* Link to a source file in the repository Gitlab: [grit_ext.rb](https://gitlab.com/gitlab-org/gitlab-grit/blob/master/lib/grit_ext.rb)

The paths to the files on the file system are specified for **omnibus-gitlab**.

### In english
In Gitlab Windows-1251 encoding is still broken in the file viewer and the commit viewer. 
In this repository i posted sample with there bug. And put fix for Gitlab.

This issue is subject to the projects in which the source code is not encoded in UTF-8.

The first mention of the problem https://github.com/gitlabhq/gitlabhq/issues/5493 This discussion of the problem was closed. Discussion moved here https://gitlab.com/gitlab-org/gitlab-ce/issues/14048

#### Source of the problem
Ruby-gem **charlock_holmes**, responsible for the recognition of source coding and transferring them to UTF-8, can not understand what gives Windows-1251 to him.

Original source patch for old Gitlab version (from 31.10.2012) http://www.jackyfox.com/2012/10/31/gitlab-non-utf-8-russian-comments/

### На русском
В Gitlab кодировка Windows-1251 по-прежнему сломана в просмотрщике файлов и просмотрщике фиксаций.
В этом хранилище я разместил образец с ошибкой. И положил исправление для Gitlab.

Этой проблеме подвержены проекты в которых исходный код не в кодировке UTF-8.

Первые упоминания о проблеме https://github.com/gitlabhq/gitlabhq/issues/5493 Это обсуждение проблемы было закрыто. Обсуждение переместилось сюда https://gitlab.com/gitlab-org/gitlab-ce/issues/14048

#### Источник проблемы
Ruby-гем **charlock_holmes**, отвечающий за распознавание кодировки исходников и перевода их в UTF-8, не может понять, что дают ему Windows-1251.

Первоначальный источник исправлений для старой версии GitLab (от 31.10.2012) http://www.jackyfox.com/2012/10/31/gitlab-non-utf-8-russian-comments/
