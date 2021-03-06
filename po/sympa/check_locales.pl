# -*- indent-tabs-mode: nil; -*-
# vim:ft=perl:et:sw=4
# $Id$

# Sympa - SYsteme de Multi-Postage Automatique
#
# Copyright (c) 1997, 1998, 1999 Institut Pasteur & Christophe Wolfhugel
# Copyright (c) 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005,
# 2006, 2007, 2008, 2009, 2010, 2011 Comite Reseau des Universites
# Copyright (c) 2011, 2012, 2013, 2014, 2015, 2016, 2017 GIP RENATER
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

use POSIX qw (setlocale);

my @locales = split /\s+/, $ENV{'SYMPA_LOCALES'};

my (@supported, @not_supported);

foreach my $loc (@locales) {
    my $locale_dashless = $loc . '.utf-8';
    $locale_dashless =~ s/-//g;
    my $lang = substr($loc, 0, 2);
    my $success;
    foreach my $try (
        $loc . '.utf-8',
        $loc . '.UTF-8',     ## UpperCase required for FreeBSD
        $locale_dashless,    ## Required on HPUX
        $loc,
        $lang
        ) {
        if (setlocale(&POSIX::LC_ALL, $try)) {
            push @supported, $loc;
            $success = 1;
            last;
        }
    }
    push @not_supported, $loc unless ($success);

}

if ($#supported == -1) {
    printf
        "#########################################################################################################\n";
    printf
        "## IMPORTANT : Sympa is not able to use locales because they are not properly configured on this server\n";
    printf "## You should activate some of the following locales :\n";
    printf "##     %s\n", join(' ', @locales);
    printf
        "## On Debian you should run the following command : dpkg-reconfigure locales\n";
    printf
        "## On others systems, check /etc/locale.gen or /etc/sysconfig/i18n files\n";
    printf
        "#########################################################################################################\n";

    my $s = $<;
} elsif ($#not_supported > -1) {
    printf
        "#############################################################################################################\n";
    printf
        "## IMPORTANT : Sympa is not able to use all supported locales because they are not properly configured on this server\n";
    printf "## Herer is a list of NOT supported locales :\n";
    printf "##     %s\n", join(' ', @not_supported);
    printf
        "## On Debian you should run the following command : dpkg-reconfigure locales\n";
    printf
        "## On others systems, check /etc/locale.gen or /etc/sysconfig/i18n files\n";
    printf
        "#############################################################################################################\n";

    my $s = $<;
}
