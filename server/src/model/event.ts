/**
 * event.ts
 *
 * @file Event enumeration
 * @author Brendan Lensink <brendan@steamclock.com>
 */

/**
 * Events received by the socket client
 */
export enum IncomingEvents {
  join = "join",
  selection = "selection",
  guess = "guess",
  connection = "connection",
  reconnected = "reconnected",
  disconnect = "disconnect"
}

export enum OutGoingEvents {
  response = "response",
  selectionSet = "selectionSet",
  guessSet = "guessSet",
  error = "error"
}