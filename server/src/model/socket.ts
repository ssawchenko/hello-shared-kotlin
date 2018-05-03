/**
 * socketManager.ts
 *
 * @file Manages instance of socket.io
 * @author Brendan Lensink <brendan@steamclock.com>
 */

import { IncomingEvents } from "./event";
import { OutGoingEvents } from "./event";
import { log } from "../log";

// Catch unhandled errors
(process as NodeJS.EventEmitter).on("uncaughtException", (error) => {
  log.error("Uncaught Exception", error, error.stack);
  process.exit(1);
});

export class Socket {
  private socket: any;
  numUsers = 0;

  constructor(socket: any) {
    this.socket = socket;
  }

  // Computed properties for socket.io

  get username(): string { return this.socket.username; }
  set username(newValue: string) { this.socket.username = newValue; }

  get userId(): string { return this.socket.username + ":" + this.socket.deviceId; }

  get id(): string { return this.socket.id; }

  /**
   * Connect a socket to a match, adding a bunch of meta-data
   *
   * @param username     The client's username
   */
  connect(username: string): void {
    this.username = username;
    // this.deviceId = deviceId;
  }

  // Emit handlers

  /**
   * Send a client error message back to the client
   *
   * @param message    The error message to pass on
   */
  public sendError(message: string): void {
    this.socket.emit(OutGoingEvents.error, { message });
  }

  /**
   * Send a client error message back to the client
   *
   * @param message    The error message to pass on
   */
  public sendResponse(message: string): void {
    this.socket.emit(OutGoingEvents.guessResponse, { message });
  }

  /**
   * Emit that a user disconnected from a match
   */
  public emitDisconnected() {
    
  }

  // Event handlers

  /**
   * Called when a users sends an action to a match
   *
   * @param handler    The function used to process their request
   */
  public onSendSelection(handler: (data: any) => void): void {
    this.socket.on(IncomingEvents.sendSelection, handler);
  }

  /**
   * Called when a users sends an action to a match
   *
   * @param handler    The function used to process their request
   */
  public onSendGuess(handler: (data: any) => void): void {
    this.socket.on(IncomingEvents.sendGuess, handler);
  }

  /**
   * Called when a users sends an action to a match
   *
   * @param handler    The function used to process their request
   */
  public onJoinGame(handler: (data: any) => void): void {
    this.socket.on(IncomingEvents.joinGame, handler);
  }

  /**
   * Called when a user reconnects to a match
   *
   * @param handler    The function used to process their request
   */
  public onReconnected(handler: (deviceId: string, matchName: string) => void): void {
    this.socket.on(IncomingEvents.reconnected, handler);
  }

  /**
   * Called when a user disconnects from a match
   *
   * @param handler    The function used to process their request
   */
  public onDisconnect(handler: (reason: any) => void): void {
    this.socket.on(IncomingEvents.disconnect, handler);
  }
}