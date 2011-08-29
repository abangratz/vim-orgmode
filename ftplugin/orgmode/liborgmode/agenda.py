# -*- coding: utf-8 -*-

"""
    Agenda
    ~~~~~~~~~~~~~~~~~~

    The agenda is one of the main concepts of orgmode.
    TODO

	* filtering
	* sorting
"""

class AgendaManager(object):
	"""Simple parsing of Documents to create an agenda."""
	def __init__(self):
		super(AgendaManager, self).__init__()

		self.agenda = []

	def get_agenda(self, document):
		""""
		Get an agenda.

		No filter support yet.
		"""

		self.agenda[:] = []
		# select items
		for heading in document.headings:
			self._select_items(heading)

		# sort items
		return self.agenda

	def _select_items(self, heading):
		"""
		recursively select new items for the agenda for a given heading.
		"""
		# print info if exist
		if heading.active_date:
			result = heading.active_date + " " + heading.title
			self.agenda.append(result)
		# select items of children
		for child in heading.children:
			self._select_items(child)

# vim: set noexpandtab: