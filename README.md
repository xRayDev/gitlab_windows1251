# Gitlab windows1251 issue fix

## Current FIX
Version Gitlab **8.12.7**

#### encoding_helper.rb
* Source file: [encoding_helper.rb](https://github.com/xRayDev/gitlab_windows1251/blob/323047eca8c8c28a8b5705bcdf7efe1ad444cc89/encoding_helper.rb)
* Path: /opt/gitlab/embedded/service/gem/ruby/2.3.0/gems/gitlab_git-**10.6.6**/lib/gitlab_git/**encoding_helper.rb**
* **Fix:** https://github.com/xRayDev/gitlab_windows1251/commit/21c7914500e3d1a8f6b68985cedfe9e65f5006d7
* Link to a source file in the repository Gitlab: [encoding_helper.rb](https://gitlab.com/gitlab-org/gitlab_git/blob/5870f87ddcf0e993e8661d366dd9a402bd5ca611/lib/gitlab_git/encoding_helper.rb)

#### grit_ext.rb
* Source file: [grit_ext.rb](https://github.com/xRayDev/gitlab_windows1251/blob/fae5ad9c645b72d1db80c28b89c3e5fea2b7a220/grit_ext.rb)
* Path: /opt/gitlab/embedded/service/gem/ruby/2.3.0/gems/gitlab-grit-**2.8.1**/lib/**grit_ext.rb**
* **Fix:** https://github.com/xRayDev/gitlab_windows1251/commit/0340b4fe93186876d78c9ce1e1de8116696280ea
* Link to a source file in the repository Gitlab: [grit_ext.rb](https://gitlab.com/gitlab-org/gitlab-grit/blob/806485740f9706b913ceaa1fa665880495fc55d1/lib/grit_ext.rb)


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
